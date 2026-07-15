import 'package:gyanburu_fin_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  final userId = const Uuid().v4();

  MonthlyEntry entry({
    required String name,
    required String month,
    double amount = 100.0,
    bool recurrent = true,
    bool variable = false,
    EntryType type = EntryType.expense,
    DateTime? dueDate,
  }) =>
      MonthlyEntry(
        userId: UuidValue.fromString(userId),
        categoryId: 1,
        name: name,
        type: type,
        amount: amount,
        month: month,
        recurrent: recurrent,
        variable: variable,
        confirmed: !variable,
        dueDate: dueDate,
        paid: false,
      );

  withServerpod('Given MonthlyEntry endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder authed;

    setUp(() {
      authed = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(userId, {}),
      );
    });

    group('Materialization', () {
      test('first access copies recurrent entries from latest prior month',
          () async {
        await endpoints.monthlyEntry.create(
          authed,
          entry(name: 'Aluguel', month: '2026-05', amount: 1500.0),
        );

        final june = await endpoints.monthlyEntry.listByMonth(
          authed,
          '2026-06',
        );
        expect(june, hasLength(1));
        expect(june.first.name, 'Aluguel');
        expect(june.first.amount, 1500.0);
        expect(june.first.paid, isFalse);
      });

      test('materializes from the month closest to the target, not the first',
          () async {
        await endpoints.monthlyEntry.create(
          authed,
          entry(name: 'Internet', month: '2026-04', amount: 99.0),
        );
        final may =
            await endpoints.monthlyEntry.listByMonth(authed, '2026-05');
        await endpoints.monthlyEntry.update(
          authed,
          may.first.copyWith(amount: 120.0),
        );

        final june =
            await endpoints.monthlyEntry.listByMonth(authed, '2026-06');
        expect(june.first.amount, 120.0);
      });
    });

    group('Edit propagation', () {
      test('amount edit reaches already-materialized future months', () async {
        final may = await endpoints.monthlyEntry.create(
          authed,
          entry(name: 'Luz', month: '2026-05', amount: 200.0),
        );
        // Browse ahead: June and July materialize with the old amount.
        await endpoints.monthlyEntry.listByMonth(authed, '2026-06');
        await endpoints.monthlyEntry.listByMonth(authed, '2026-07');

        await endpoints.monthlyEntry.update(
          authed,
          may.copyWith(amount: 250.0),
        );

        final june =
            await endpoints.monthlyEntry.listByMonth(authed, '2026-06');
        final july =
            await endpoints.monthlyEntry.listByMonth(authed, '2026-07');
        expect(june.single.amount, 250.0);
        expect(july.single.amount, 250.0);
      });

      test('rename propagates by matching the pre-edit name', () async {
        final may = await endpoints.monthlyEntry.create(
          authed,
          entry(name: 'Vivo', month: '2026-05', amount: 80.0),
        );
        await endpoints.monthlyEntry.listByMonth(authed, '2026-06');

        await endpoints.monthlyEntry.update(
          authed,
          may.copyWith(name: 'Vivo Fibra', amount: 90.0),
        );

        final june =
            await endpoints.monthlyEntry.listByMonth(authed, '2026-06');
        expect(june.single.name, 'Vivo Fibra');
        expect(june.single.amount, 90.0);
      });

      test('paid future entries are not overwritten', () async {
        final may = await endpoints.monthlyEntry.create(
          authed,
          entry(name: 'Academia', month: '2026-05', amount: 110.0),
        );
        final june =
            await endpoints.monthlyEntry.listByMonth(authed, '2026-06');
        await endpoints.monthlyEntry.update(
          authed,
          june.single.copyWith(paid: true, paidAt: DateTime.now()),
        );

        await endpoints.monthlyEntry.update(
          authed,
          may.copyWith(amount: 130.0),
        );

        final juneAfter =
            await endpoints.monthlyEntry.listByMonth(authed, '2026-06');
        expect(juneAfter.single.amount, 110.0);
      });

      test('toggling confirmed alone does not clobber a customized future month',
          () async {
        final may = await endpoints.monthlyEntry.create(
          authed,
          entry(name: 'Mercado', month: '2026-05', amount: 600.0,
              variable: true),
        );
        final june =
            await endpoints.monthlyEntry.listByMonth(authed, '2026-06');
        await endpoints.monthlyEntry.update(
          authed,
          june.single.copyWith(amount: 750.0),
        );

        // Confirm May without changing any propagatable field.
        await endpoints.monthlyEntry.update(
          authed,
          may.copyWith(confirmed: true),
        );

        final juneAfter =
            await endpoints.monthlyEntry.listByMonth(authed, '2026-06');
        expect(juneAfter.single.amount, 750.0);
      });

      test('edits from a past month do not touch earlier months', () async {
        await endpoints.monthlyEntry.create(
          authed,
          entry(name: 'Seguro', month: '2026-05', amount: 300.0),
        );
        final june =
            await endpoints.monthlyEntry.listByMonth(authed, '2026-06');

        await endpoints.monthlyEntry.update(
          authed,
          june.single.copyWith(amount: 350.0),
        );

        final may = await endpoints.monthlyEntry.listByMonth(authed, '2026-05');
        expect(may.single.amount, 300.0);
      });
    });

    group('Create propagation', () {
      test('new recurrent entry backfills already-materialized future months',
          () async {
        await endpoints.monthlyEntry.create(
          authed,
          entry(name: 'Aluguel', month: '2026-05', amount: 1500.0),
        );
        await endpoints.monthlyEntry.listByMonth(authed, '2026-06');

        await endpoints.monthlyEntry.create(
          authed,
          entry(name: 'Streaming', month: '2026-05', amount: 40.0),
        );

        final june =
            await endpoints.monthlyEntry.listByMonth(authed, '2026-06');
        expect(june, hasLength(2));
        expect(
          june.firstWhere((e) => e.name == 'Streaming').amount,
          40.0,
        );
      });

      test('non-recurrent entries stay in their own month', () async {
        await endpoints.monthlyEntry.create(
          authed,
          entry(name: 'Aluguel', month: '2026-05', amount: 1500.0),
        );
        await endpoints.monthlyEntry.listByMonth(authed, '2026-06');

        await endpoints.monthlyEntry.create(
          authed,
          entry(
            name: 'Presente',
            month: '2026-05',
            amount: 200.0,
            recurrent: false,
          ),
        );

        final june =
            await endpoints.monthlyEntry.listByMonth(authed, '2026-06');
        expect(june.where((e) => e.name == 'Presente'), isEmpty);
      });
    });

    group('User isolation', () {
      test('update fails for another user entry', () async {
        final mine = await endpoints.monthlyEntry.create(
          authed,
          entry(name: 'Aluguel', month: '2026-05', amount: 1500.0),
        );

        final otherAuthed = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            const Uuid().v4(),
            {},
          ),
        );

        expect(
          () => endpoints.monthlyEntry.update(
            otherAuthed,
            mine.copyWith(amount: 1.0),
          ),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
