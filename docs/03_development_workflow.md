# Development Workflow

## Adding a new model

1. Create `gyanburu_fin_server/lib/src/models/your_model.spy.yaml`:

```yaml
class: YourModel
table: your_models
fields:
  userId: int
  amount: double
  description: String?
  createdAt: DateTime
indexes:
  your_models_user_idx:
    fields: userId
```

2. Run the generator:

```bash
cd gyanburu_fin_server
dart run serverpod_cli generate
```

3. Create a migration:

```bash
dart run serverpod_cli create-migration
```

4. Apply it (restart the server with `--apply-migrations` or run directly):

```bash
dart bin/main.dart --apply-migrations
```

## Adding a new endpoint

1. Create `gyanburu_fin_server/lib/src/endpoints/your_endpoint.dart`:

```dart
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class YourEndpoint extends Endpoint {
  Future<YourModel> create(Session session, YourModel data) async {
    return await YourModel.db.insertRow(session, data);
  }

  Future<List<YourModel>> list(Session session) async {
    return await YourModel.db.find(session);
  }
}
```

2. Register it in `lib/src/server.dart` (auto-done by generator if named correctly).

3. Run the generator again — the client gets the new methods automatically.

## Requiring authentication on an endpoint

```dart
class YourEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<YourModel> list(Session session) async {
    // session.auth.authenticatedUserId is available here
    final userId = await session.auth.authenticatedUserId;
    return await YourModel.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );
  }
}
```

## Database queries

```dart
// Find with filter
final rows = await Transaction.db.find(
  session,
  where: (t) => t.userId.equals(userId) & t.amount.greaterThan(0),
  orderBy: (t) => t.createdAt,
  orderDescending: true,
  limit: 50,
);

// Insert
final created = await Transaction.db.insertRow(session, newTx);

// Update
await Transaction.db.updateRow(session, updatedTx);

// Delete
await Transaction.db.deleteRow(session, tx);
```

## Common gotchas

- Always run `generate` after changing any `.spy.yaml` or endpoint signature.
- Migration files are committed to version control — don't delete them.
- `passwords.yaml` should never be committed with real credentials. Use env vars in production.
- Redis is disabled by default in `development.yaml`. Enable it only when you need caching or pub/sub.
- The `serverpod_auth_idp_server` package is included — it supports custom auth flows (no built-in email/Serverpod IDP required, consistent with this project's auth pattern).
