import 'package:gyanburu_fin_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  final userId = const Uuid().v4();

  withServerpod('Given Bill endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder authed;

    setUp(() {
      authed = sessionBuilder.copyWith(
        authentication:
            AuthenticationOverride.authenticationInfo(userId, {}),
      );
    });

    group('CRUD', () {
      test('create and list returns the bill', () async {
        await endpoints.bill.create(
          authed,
          Bill(
            userId: UuidValue.fromString(userId),
            merchantName: 'Vivo Internet',
            amount: 149.90,
            dueAt: DateTime.now().add(const Duration(days: 5)),
            status: BillStatus.pending,
            recurrent: true,
          ),
        );

        final list = await endpoints.bill.list(authed);
        expect(list, hasLength(1));
        expect(list.first.merchantName, 'Vivo Internet');
      });

      test('markAsPaid updates status', () async {
        final bill = await endpoints.bill.create(
          authed,
          Bill(
            userId: UuidValue.fromString(userId),
            merchantName: 'Electric Bill',
            amount: 200.0,
            dueAt: DateTime.now().add(const Duration(days: 3)),
            status: BillStatus.pending,
            recurrent: false,
          ),
        );

        final paid = await endpoints.bill.markAsPaid(authed, bill.id!);
        expect(paid.status, BillStatus.paid);
      });
    });

    group('Validation', () {
      test('rejects empty merchant name', () async {
        expect(
          () => endpoints.bill.create(
            authed,
            Bill(
              userId: UuidValue.fromString(userId),
              merchantName: '',
              amount: 100.0,
              dueAt: DateTime.now(),
              status: BillStatus.pending,
              recurrent: false,
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('rejects zero amount', () async {
        expect(
          () => endpoints.bill.create(
            authed,
            Bill(
              userId: UuidValue.fromString(userId),
              merchantName: 'Test',
              amount: 0.0,
              dueAt: DateTime.now(),
              status: BillStatus.pending,
              recurrent: false,
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('rejects negative amount', () async {
        expect(
          () => endpoints.bill.create(
            authed,
            Bill(
              userId: UuidValue.fromString(userId),
              merchantName: 'Test',
              amount: -50.0,
              dueAt: DateTime.now(),
              status: BillStatus.pending,
              recurrent: false,
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('User isolation', () {
      test('markAsPaid fails for another user bill', () async {
        final bill = await endpoints.bill.create(
          authed,
          Bill(
            userId: UuidValue.fromString(userId),
            merchantName: 'Private Bill',
            amount: 300.0,
            dueAt: DateTime.now(),
            status: BillStatus.pending,
            recurrent: false,
          ),
        );

        final otherUserId = const Uuid().v4();
        final otherAuthed = sessionBuilder.copyWith(
          authentication:
              AuthenticationOverride.authenticationInfo(otherUserId, {}),
        );

        expect(
          () => endpoints.bill.markAsPaid(otherAuthed, bill.id!),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
