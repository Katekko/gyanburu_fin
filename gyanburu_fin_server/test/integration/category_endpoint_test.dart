import 'package:gyanburu_fin_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  final userId = const Uuid().v4();

  withServerpod('Given Category endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder authed;

    setUp(() {
      authed = sessionBuilder.copyWith(
        authentication:
            AuthenticationOverride.authenticationInfo(userId, {}),
      );
    });

    group('CRUD', () {
      test('create and list returns the category', () async {
        await endpoints.category.create(
          authed,
          Category(
            userId: UuidValue.fromString(userId),
            name: 'Food',
            icon: 'restaurant',
            color: 'FF7043',
          ),
        );

        final list = await endpoints.category.list(authed);
        expect(list, hasLength(1));
        expect(list.first.name, 'Food');
        expect(list.first.icon, 'restaurant');
      });

      test('update changes fields', () async {
        final created = await endpoints.category.create(
          authed,
          Category(
            userId: UuidValue.fromString(userId),
            name: 'Food',
            icon: 'restaurant',
            color: 'FF7043',
          ),
        );

        created.name = 'Dining';
        final updated = await endpoints.category.update(authed, created);
        expect(updated.name, 'Dining');
      });

      test('delete removes the category', () async {
        final created = await endpoints.category.create(
          authed,
          Category(
            userId: UuidValue.fromString(userId),
            name: 'Temp',
            icon: 'delete',
            color: '000000',
          ),
        );

        await endpoints.category.delete(authed, created.id!);
        final list = await endpoints.category.list(authed);
        expect(list, isEmpty);
      });
    });

    group('Validation', () {
      test('rejects empty name', () async {
        expect(
          () => endpoints.category.create(
            authed,
            Category(
              userId: UuidValue.fromString(userId),
              name: '',
              icon: 'restaurant',
              color: 'FF7043',
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('accepts bare hex color (client default)', () async {
        await endpoints.category.create(
          authed,
          Category(
            userId: UuidValue.fromString(userId),
            name: 'Bare',
            icon: 'palette',
            color: '4CAF50',
          ),
        );
        final list = await endpoints.category.list(authed);
        expect(list, hasLength(1));
        expect(list.first.color, '4CAF50');
      });

      test('accepts hash-prefixed hex color', () async {
        await endpoints.category.create(
          authed,
          Category(
            userId: UuidValue.fromString(userId),
            name: 'Hashed',
            icon: 'palette',
            color: '#4CAF50',
          ),
        );
        final list = await endpoints.category.list(authed);
        expect(list, hasLength(1));
        expect(list.first.color, '#4CAF50');
      });

      test('rejects invalid hex color', () async {
        expect(
          () => endpoints.category.create(
            authed,
            Category(
              userId: UuidValue.fromString(userId),
              name: 'Food',
              icon: 'restaurant',
              color: 'not-a-color',
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('rejects short hex color', () async {
        expect(
          () => endpoints.category.create(
            authed,
            Category(
              userId: UuidValue.fromString(userId),
              name: 'Food',
              icon: 'restaurant',
              color: 'FFF',
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('User isolation', () {
      test('user cannot see another user categories', () async {
        final otherUserId = const Uuid().v4();
        final otherAuthed = sessionBuilder.copyWith(
          authentication:
              AuthenticationOverride.authenticationInfo(otherUserId, {}),
        );

        await endpoints.category.create(
          authed,
          Category(
            userId: UuidValue.fromString(userId),
            name: 'MyCategory',
            icon: 'star',
            color: 'FFFFFF',
          ),
        );

        final otherList = await endpoints.category.list(otherAuthed);
        expect(otherList, isEmpty);
      });

      test('user cannot delete another user category', () async {
        final created = await endpoints.category.create(
          authed,
          Category(
            userId: UuidValue.fromString(userId),
            name: 'Protected',
            icon: 'lock',
            color: 'FF0000',
          ),
        );

        final otherUserId = const Uuid().v4();
        final otherAuthed = sessionBuilder.copyWith(
          authentication:
              AuthenticationOverride.authenticationInfo(otherUserId, {}),
        );

        await endpoints.category.delete(otherAuthed, created.id!);

        // Original user should still see it
        final list = await endpoints.category.list(authed);
        expect(list, hasLength(1));
      });
    });
  });
}
