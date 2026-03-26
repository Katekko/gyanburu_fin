# Quickstart — gyanburu_fin

Serverpod 3.4.4 | Dart SDK ^3.8.0

## Prerequisites

- Docker + Docker Compose
- Dart SDK >= 3.8
- Flutter SDK
- `serverpod_cli` activated: `dart pub global activate serverpod_cli`

## First run

```bash
# 1. Start Postgres + Redis via Docker
cd ~/Projects/gyanburu_fin/gyanburu_fin_server
docker compose up --build --detach

# 2. Start the server (applies migrations on first run)
dart bin/main.dart --apply-migrations

# 3. Run the Flutter app (separate terminal)
cd ~/Projects/gyanburu_fin/gyanburu_fin_flutter
flutter run
```

## Ports

| Service       | Port  |
|---------------|-------|
| API server    | 8080  |
| Insights      | 8081  |
| Web server    | 8082  |
| Postgres (DB) | 8090  |
| Redis         | 8091  |

Database name: `gyanburu_fin` | User: `postgres`

Password is in `gyanburu_fin_server/config/passwords.yaml`.

## Useful scripts (run from server dir)

```bash
# Generate code after changing models/endpoints
dart run serverpod_cli generate

# Apply pending migrations
dart bin/main.dart --apply-migrations

# Build Flutter web and copy to server's web/ dir
dart run serverpod_cli run flutter_build
```

## Stop everything

```bash
cd gyanburu_fin_server
docker compose down
```

To also wipe the database volume:

```bash
docker compose down -v
```
