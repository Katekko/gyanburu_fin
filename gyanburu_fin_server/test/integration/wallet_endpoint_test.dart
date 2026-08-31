import 'package:gyanburu_fin_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  final userId = const Uuid().v4();

  withServerpod('Given Wallet endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder authed;

    setUp(() {
      authed = sessionBuilder.copyWith(
        authentication:
            AuthenticationOverride.authenticationInfo(userId, {}),
      );
    });

    group('wallet bootstrap', () {
      test('summaries lazily creates comida and home-office wallets',
          () async {
        final summaries =
            await endpoints.wallet.summaries(authed, DateTime(2026, 9));

        expect(summaries, hasLength(2));
        expect(
          summaries.map((s) => s.wallet.slug),
          containsAll(['comida', 'home-office']),
        );
        for (final s in summaries) {
          expect(s.balance, 0);
          expect(s.monthSpent, 0);
          expect(s.monthToppedUp, 0);
          expect(s.wallet.provider, 'caju');
        }
      });

      test('summaries does not duplicate wallets on repeated calls',
          () async {
        await endpoints.wallet.summaries(authed, DateTime(2026, 9));
        final again =
            await endpoints.wallet.summaries(authed, DateTime(2026, 9));
        expect(again, hasLength(2));
      });
    });

    group('spend', () {
      test('records a negative caju transaction with the category name',
          () async {
        final category = await endpoints.category.create(
          authed,
          Category(
            userId: UuidValue.fromString(userId),
            name: 'Fastfood',
            icon: 'fastfood',
            color: 'FF7043',
          ),
        );

        final tx = await endpoints.wallet.spend(
          authed,
          'comida',
          45.9,
          'iFood',
          category.id,
          DateTime.utc(2026, 9, 5, 12),
          null,
        );

        expect(tx.amount, 45.9);
        expect(tx.category, 'Fastfood');
        expect(tx.source, 'caju');
        expect(tx.kind, 'expense');
        expect(tx.walletId, isNotNull);

        final summaries =
            await endpoints.wallet.summaries(authed, DateTime(2026, 9));
        final comida =
            summaries.singleWhere((s) => s.wallet.slug == 'comida');
        expect(comida.balance, closeTo(-45.9, 0.001));
        expect(comida.monthSpent, closeTo(45.9, 0.001));
      });

      test('applies a category rule when no category is given', () async {
        final category = await endpoints.category.create(
          authed,
          Category(
            userId: UuidValue.fromString(userId),
            name: 'Mantimentos',
            icon: 'cart',
            color: '43A047',
          ),
        );
        await CategoryRule.db.insertRow(
          sessionBuilder.build(),
          CategoryRule(
            userId: UuidValue.fromString(userId),
            merchantPattern: 'Mercado Bom Preço',
            categoryId: category.id,
            displayName: 'Mercado',
          ),
        );

        final tx = await endpoints.wallet.spend(
          authed,
          'comida',
          120,
          'Mercado Bom Preço',
          null,
          DateTime.utc(2026, 9, 6, 10),
          null,
        );

        expect(tx.category, 'Mantimentos');
        expect(tx.displayName, 'Mercado');
      });

      test('rejects an unknown wallet slug', () async {
        await expectLater(
          endpoints.wallet.spend(
            authed,
            'refeicao',
            10,
            'iFood',
            null,
            null,
            null,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('topup', () {
      test('records a positive topup transaction', () async {
        final tx = await endpoints.wallet.topup(
          authed,
          'home-office',
          150,
          DateTime.utc(2026, 9, 1, 8),
          null,
        );

        expect(tx.amount, 150);
        expect(tx.kind, 'topup');
        expect(tx.source, 'caju');

        final summaries =
            await endpoints.wallet.summaries(authed, DateTime(2026, 9));
        final home =
            summaries.singleWhere((s) => s.wallet.slug == 'home-office');
        expect(home.balance, closeTo(150, 0.001));
        expect(home.monthToppedUp, closeTo(150, 0.001));
        expect(home.monthSpent, 0);
      });

      test('falls back to the configured monthly amount', () async {
        await endpoints.wallet.setMonthlyTopup(authed, 'comida', 1490);
        final tx = await endpoints.wallet.topup(
          authed,
          'comida',
          null,
          DateTime.utc(2026, 9, 1, 8),
          null,
        );
        expect(tx.amount, 1490);
      });

      test('fails without an amount when none is configured', () async {
        await expectLater(
          endpoints.wallet.topup(authed, 'comida', null, null, null),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('setBalance', () {
      test('anchors the balance and ignores older transactions', () async {
        await endpoints.wallet.spend(
          authed,
          'comida',
          100,
          'Padaria',
          null,
          DateTime.utc(2026, 8, 20, 12),
          null,
        );

        await endpoints.wallet.setBalance(
          authed,
          'comida',
          1426.94,
          DateTime.utc(2026, 8, 31, 23, 59),
        );

        await endpoints.wallet.spend(
          authed,
          'comida',
          50,
          'iFood',
          null,
          DateTime.utc(2026, 9, 2, 20),
          null,
        );

        final summaries =
            await endpoints.wallet.summaries(authed, DateTime(2026, 9));
        final comida =
            summaries.singleWhere((s) => s.wallet.slug == 'comida');
        expect(comida.balance, closeTo(1426.94 - 50, 0.001));
      });
    });

    group('monthTransactions', () {
      test('returns only wallet transactions inside the month', () async {
        await endpoints.wallet.spend(
          authed,
          'comida',
          10,
          'Dentro do mês',
          null,
          DateTime.utc(2026, 9, 10, 12),
          null,
        );
        await endpoints.wallet.spend(
          authed,
          'comida',
          20,
          'Fora do mês',
          null,
          DateTime.utc(2026, 8, 10, 12),
          null,
        );
        await endpoints.transaction.create(
          authed,
          FinancialTransaction(
            userId: UuidValue.fromString(userId),
            merchantName: 'Nubank não-caju',
            category: '',
            amount: -30,
            currency: 'BRL',
            occurredAt: DateTime.utc(2026, 9, 11, 12),
          ),
        );

        final list = await endpoints.wallet
            .monthTransactions(authed, DateTime(2026, 9));
        expect(list, hasLength(1));
        expect(list.single.merchantName, 'Dentro do mês');
      });
    });

    group('deleteTransaction', () {
      test('removes a wallet transaction and restores the balance', () async {
        final tx = await endpoints.wallet.spend(
          authed,
          'comida',
          33,
          'Erro de digitação',
          null,
          DateTime.utc(2026, 9, 3, 12),
          null,
        );
        await endpoints.wallet.deleteTransaction(authed, tx.id!);

        final summaries =
            await endpoints.wallet.summaries(authed, DateTime(2026, 9));
        final comida =
            summaries.singleWhere((s) => s.wallet.slug == 'comida');
        expect(comida.balance, 0);
        expect(comida.monthSpent, 0);
      });
    });
  });
}
