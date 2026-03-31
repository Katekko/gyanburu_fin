import 'package:gyanburu_fin_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

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
