# Project Structure

```
gyanburu_fin/
├── gyanburu_fin_server/       # Dart server (Serverpod)
│   ├── bin/main.dart          # Entry point
│   ├── lib/src/
│   │   ├── endpoints/         # API endpoints (one class per domain)
│   │   └── generated/         # Auto-generated — DO NOT edit manually
│   ├── migrations/            # DB migration files (auto-generated)
│   ├── config/
│   │   ├── development.yaml   # Local dev config
│   │   ├── staging.yaml
│   │   ├── production.yaml
│   │   └── passwords.yaml     # DB/Redis passwords (gitignored in prod)
│   ├── docker-compose.yaml    # Postgres + Redis for local dev
│   └── pubspec.yaml
│
├── gyanburu_fin_client/       # Auto-generated Dart client (shared)
│   └── lib/src/protocol/      # Generated models + client stubs
│
├── gyanburu_fin_flutter/      # Flutter app
│   ├── lib/
│   │   └── main.dart
│   └── pubspec.yaml
│
└── pubspec.yaml               # Workspace root
```

## Key rule: generated code

Everything inside `lib/src/generated/` and `gyanburu_fin_client/lib/src/protocol/`
is **auto-generated** by `dart run serverpod_cli generate`.

Never edit those files. Define your models in YAML files and your endpoint logic
in `lib/src/endpoints/`. Run the generator after every change.

## Model definition files

Models live as `.spy.yaml` files alongside your server code:

```
gyanburu_fin_server/lib/src/models/
├── transaction.spy.yaml
├── budget_category.spy.yaml
└── ...
```

After creating/editing a `.spy.yaml`, always run:

```bash
dart run serverpod_cli generate
```

## Endpoints

Each endpoint class extends `Endpoint` and lives in `lib/src/endpoints/`.
Methods automatically become callable from the Flutter client after generation.

```dart
// lib/src/endpoints/transaction_endpoint.dart
class TransactionEndpoint extends Endpoint {
  Future<List<Transaction>> getRecent(Session session) async {
    return await Transaction.db.find(session, limit: 20);
  }
}
```

The generated client call in Flutter:

```dart
final txs = await client.transaction.getRecent();
```
