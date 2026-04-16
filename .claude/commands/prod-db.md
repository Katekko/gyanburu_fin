# prod-db — Production Database Access

Run queries or inspect the production Postgres database via SSH + Docker.

The server is on Tailscale. You need to be connected to run any command.
All work directory references assume `/opt/gyanburu_fin/gyanburu_fin_server`
on the remote host. The SSH credentials come from the user's shell config
or the `SERVER_USER` / `SERVER_HOST` values in `docs/08_production_access.md`.

## How to use this skill

Invoke with a natural language description of what you want to check or
do on the production database. Examples:

- `/prod-db how many transactions does each user have?`
- `/prod-db show me all category rules`
- `/prod-db find uncategorized bank expenses from this month`
- `/prod-db run the pending migrations`
- `/prod-db tail the server logs`

## Execution instructions

1. Read `docs/08_production_access.md` to confirm the exact docker compose
   commands and column names for the current schema.
2. Check `gyanburu_fin_server/lib/src/models/` for field names if the
   query touches column names — Postgres stores them quoted in camelCase
   (e.g. `"userId"`, `"occurredAt"`, `"billingMonth"`).
3. Build a minimal, read-safe command first (SELECT / logs / status).
   For writes or destructive operations (DELETE, UPDATE, migrations),
   show the command to the user and ask for confirmation before running.
4. Run via Bash using the pattern:
   ```
   ssh <USER>@<HOST> "cd /opt/gyanburu_fin/gyanburu_fin_server && \
     docker compose -f docker-compose.prod.yaml exec -T postgres \
     psql -U postgres gyanburu_fin -c \"<SQL>\""
   ```
5. Present results cleanly — summarize row counts, highlight anomalies,
   suggest follow-up queries if relevant.

## Safety rules

- Never run DROP, TRUNCATE, or DELETE without explicit user confirmation.
- Never print or log `passwords.yaml` contents or env vars.
- Prefer `-T` (non-TTY) on all `docker compose exec` calls so they work
  non-interactively from Bash.
