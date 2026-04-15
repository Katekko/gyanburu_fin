import 'package:gyanburu_fin_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  final userId = const Uuid().v4();

  withServerpod('Given Transaction endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder authed;

    setUp(() {
      authed = sessionBuilder.copyWith(
        authentication:
            AuthenticationOverride.authenticationInfo(userId, {}),
      );
    });

    group('CRUD', () {
      test('create and list returns transaction', () async {
        final now = DateTime.now();
        await endpoints.transaction.create(
          authed,
          FinancialTransaction(
            userId: UuidValue.fromString(userId),
            merchantName: 'Uber Eats',
            category: 'Food',
            amount: 42.90,
            currency: 'BRL',
            occurredAt: now,
          ),
        );

        final list = await endpoints.transaction.listByMonth(authed, now);
        expect(list, hasLength(1));
        expect(list.first.merchantName, 'Uber Eats');
        expect(list.first.amount, 42.90);
      });

      test('delete removes the transaction', () async {
        final created = await endpoints.transaction.create(
          authed,
          FinancialTransaction(
            userId: UuidValue.fromString(userId),
            merchantName: 'Spotify',
            category: 'Entertainment',
            amount: 21.90,
            currency: 'BRL',
            occurredAt: DateTime.now(),
          ),
        );

        await endpoints.transaction.delete(authed, created.id!);
        final list = await endpoints.transaction
            .listByMonth(authed, DateTime.now());
        expect(list, isEmpty);
      });
    });

    group('Validation', () {
      test('rejects empty merchant name', () async {
        expect(
          () => endpoints.transaction.create(
            authed,
            FinancialTransaction(
              userId: UuidValue.fromString(userId),
              merchantName: '',
              category: 'Food',
              amount: 10.0,
              currency: 'BRL',
              occurredAt: DateTime.now(),
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('rejects empty currency', () async {
        expect(
          () => endpoints.transaction.create(
            authed,
            FinancialTransaction(
              userId: UuidValue.fromString(userId),
              merchantName: 'Test',
              category: 'Food',
              amount: 10.0,
              currency: '',
              occurredAt: DateTime.now(),
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('Month filtering', () {
      test('manual transactions (no billingMonth) fall back to occurredAt',
          () async {
        await endpoints.transaction.create(
          authed,
          FinancialTransaction(
            userId: UuidValue.fromString(userId),
            merchantName: 'Manual March',
            category: 'Food',
            amount: 10.0,
            currency: 'BRL',
            occurredAt: DateTime(2026, 3, 15),
          ),
        );

        final march = await endpoints.transaction
            .listByMonth(authed, DateTime(2026, 3));
        expect(march, hasLength(1));

        final april = await endpoints.transaction
            .listByMonth(authed, DateTime(2026, 4));
        expect(april, isEmpty);
      });

      test('billingMonth overrides occurredAt for month filtering', () async {
        final tx = FinancialTransaction(
          userId: UuidValue.fromString(userId),
          merchantName: 'Fatura Tail',
          category: 'Shopping',
          amount: 99.0,
          currency: 'BRL',
          occurredAt: DateTime(2026, 3, 31),
          billingMonth: '2026-04',
        );
        await FinancialTransaction.db.insertRow(
          sessionBuilder.build(),
          tx,
        );

        final march = await endpoints.transaction
            .listByMonth(authed, DateTime(2026, 3));
        expect(march, isEmpty,
            reason: 'billingMonth 2026-04 should hide this from March');

        final april = await endpoints.transaction
            .listByMonth(authed, DateTime(2026, 4));
        expect(april, hasLength(1));
        expect(april.first.merchantName, 'Fatura Tail');
      });
    });

    group('saveWithPropagation', () {
      Future<FinancialTransaction> _insertTx({
        required String merchant,
        String? display,
        String category = '',
      }) async {
        return FinancialTransaction.db.insertRow(
          sessionBuilder.build(),
          FinancialTransaction(
            userId: UuidValue.fromString(userId),
            merchantName: merchant,
            category: category,
            amount: 10.0,
            currency: 'BRL',
            occurredAt: DateTime(2026, 4, 10),
            displayName: display,
          ),
        );
      }

      test(
          'with propagate=true, applies displayName and category '
          'to siblings and creates a shared rule', () async {
        final cat = await endpoints.category.create(
          authed,
          Category(
            userId: UuidValue.fromString(userId),
            name: 'Transport',
            icon: 'directions_car',
            color: 'FF7043',
          ),
        );
        final a = await _insertTx(merchant: 'LAGUNA MOTORS');
        final b = await _insertTx(merchant: 'LAGUNA MOTORS');

        await endpoints.transaction.saveWithPropagation(
          authed,
          a.id!,
          'Transport',
          'Moto Stuff',
          true,
        );

        final reloadedA =
            await FinancialTransaction.db.findById(sessionBuilder.build(), a.id!);
        final reloadedB =
            await FinancialTransaction.db.findById(sessionBuilder.build(), b.id!);
        expect(reloadedA!.displayName, 'Moto Stuff');
        expect(reloadedA.category, 'Transport');
        expect(reloadedB!.displayName, 'Moto Stuff');
        expect(reloadedB.category, 'Transport');

        final rules = await endpoints.categoryRule.list(authed);
        final rule = rules
            .firstWhere((r) => r.merchantPattern == 'LAGUNA MOTORS');
        expect(rule.displayName, 'Moto Stuff');
        expect(rule.categoryId, cat.id);
      });

      test(
          'with propagate=false, sets per-transaction name, clears siblings '
          'displayName, and leaves only category on the rule', () async {
        await endpoints.category.create(
          authed,
          Category(
            userId: UuidValue.fromString(userId),
            name: 'Moto',
            icon: 'two_wheeler',
            color: 'FFAB00',
          ),
        );
        // Simulate the current broken state: both siblings share a
        // propagated displayName.
        final a = await _insertTx(
            merchant: 'LAGUNA MOTORS',
            display: 'manutencao geral',
            category: 'Moto');
        final b = await _insertTx(
            merchant: 'LAGUNA MOTORS',
            display: 'manutencao geral',
            category: 'Moto');

        await endpoints.transaction.saveWithPropagation(
          authed,
          a.id!,
          'Moto',
          'Capacete rosa',
          false,
        );

        final reloadedA =
            await FinancialTransaction.db.findById(sessionBuilder.build(), a.id!);
        final reloadedB =
            await FinancialTransaction.db.findById(sessionBuilder.build(), b.id!);
        expect(reloadedA!.displayName, 'Capacete rosa');
        expect(reloadedA.category, 'Moto');
        expect(reloadedB!.displayName, isNull,
            reason: 'sibling displayName cleared on uncheck so user can '
                'edit it individually');
        expect(reloadedB.category, 'Moto',
            reason: 'category always propagates');

        final rules = await endpoints.categoryRule.list(authed);
        final rule = rules
            .firstWhere((r) => r.merchantPattern == 'LAGUNA MOTORS');
        expect(rule.displayName, isNull);
        expect(rule.categoryId, isNotNull);
      });

      test('deletes the rule when both category and display are cleared',
          () async {
        await endpoints.category.create(
          authed,
          Category(
            userId: UuidValue.fromString(userId),
            name: 'Misc',
            icon: 'more_horiz',
            color: 'FFFFFF',
          ),
        );
        final a = await _insertTx(
            merchant: 'ONETIME MERCHANT',
            display: 'old',
            category: 'Misc');

        await endpoints.transaction.saveWithPropagation(
          authed,
          a.id!,
          null,
          null,
          false,
        );

        final rules = await endpoints.categoryRule.list(authed);
        expect(
          rules.where((r) => r.merchantPattern == 'ONETIME MERCHANT'),
          isEmpty,
        );
      });

      test('refuses to edit a transaction from another user', () async {
        final a = await _insertTx(merchant: 'PROTECTED');

        final otherAuthed = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
              const Uuid().v4(), {}),
        );

        expect(
          () => endpoints.transaction.saveWithPropagation(
            otherAuthed,
            a.id!,
            'X',
            'Y',
            true,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('User isolation', () {
      test('user cannot see another user transactions', () async {
        await endpoints.transaction.create(
          authed,
          FinancialTransaction(
            userId: UuidValue.fromString(userId),
            merchantName: 'Secret Purchase',
            category: 'Shopping',
            amount: 99.99,
            currency: 'BRL',
            occurredAt: DateTime.now(),
          ),
        );

        final otherUserId = const Uuid().v4();
        final otherAuthed = sessionBuilder.copyWith(
          authentication:
              AuthenticationOverride.authenticationInfo(otherUserId, {}),
        );

        final otherList = await endpoints.transaction
            .listByMonth(otherAuthed, DateTime.now());
        expect(otherList, isEmpty);
      });

      test('user cannot delete another user transaction', () async {
        final created = await endpoints.transaction.create(
          authed,
          FinancialTransaction(
            userId: UuidValue.fromString(userId),
            merchantName: 'Protected',
            category: 'Shopping',
            amount: 50.0,
            currency: 'BRL',
            occurredAt: DateTime.now(),
          ),
        );

        final otherUserId = const Uuid().v4();
        final otherAuthed = sessionBuilder.copyWith(
          authentication:
              AuthenticationOverride.authenticationInfo(otherUserId, {}),
        );

        await endpoints.transaction.delete(otherAuthed, created.id!);

        final list = await endpoints.transaction
            .listByMonth(authed, DateTime.now());
        expect(list, hasLength(1));
      });
    });
  });
}
