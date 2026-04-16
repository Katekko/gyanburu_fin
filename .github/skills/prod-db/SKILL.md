---
name: prod-db
description: "Query or manage the gyanburu_fin production Postgres database via SSH and Docker. Use this when asked to check production data, run SQL queries, inspect migrations, tail server logs, or troubleshoot the production environment."
---

# Production Database Access

The gyanburu_fin server runs in a Proxmox LXC reachable only over Tailscale.

## Connection

```bash
ssh root@192.168.0.229
cd /opt/gyanburu_fin/gyanburu_fin_server
```

## Running SQL queries

One-off (non-interactive, preferred):

```bash
docker compose -f docker-compose.prod.yaml exec -T postgres \
  psql -U postgres gyanburu_fin -c "<SQL>"
```

Interactive shell:

```bash
docker compose -f docker-compose.prod.yaml exec postgres \
  psql -U postgres gyanburu_fin
```

## Column naming convention

Postgres columns are **camelCase quoted identifiers**. Always quote them:

`"userId"`, `"merchantName"`, `"occurredAt"`, `"billingMonth"`, `"externalId"`, `"source"`, `"kind"`, `"displayName"`, `"installmentCurrent"`, `"installmentTotal"`, `"categoryId"`, `"merchantPattern"`.

## Key tables

| Table | Purpose |
|---|---|
| `financial_transaction` | All transactions (credit card + bank) |
| `category_rule` | Auto-categorization rules per merchant |
| `category` | User-defined categories |
| `import_history` | Log of every OFX import |
| `serverpod_migrations` | Applied migration versions |

## Useful queries

```sql
-- Applied migrations
SELECT module, version, timestamp
FROM serverpod_migrations ORDER BY timestamp DESC;

-- Transaction counts per user
SELECT "userId", COUNT(*), SUM(amount) AS total
FROM financial_transaction GROUP BY "userId";

-- Uncategorized bank expenses
SELECT id, "merchantName", amount, "occurredAt"
FROM financial_transaction
WHERE source = 'bank' AND category = '' AND kind = 'expense'
ORDER BY "occurredAt" DESC LIMIT 20;

-- Category rules
SELECT "merchantPattern", "displayName", "categoryId"
FROM category_rule;

-- Monthly spending by source
SELECT "source", "kind", COUNT(*), SUM(amount)
FROM financial_transaction
WHERE "occurredAt" >= date_trunc('month', now())
GROUP BY "source", "kind";
```

## Server control

```bash
# Live logs
docker compose -f docker-compose.prod.yaml logs -f server

# Last N lines
docker compose -f docker-compose.prod.yaml logs --tail=200 server

# Restart
docker compose -f docker-compose.prod.yaml restart server

# Apply migrations manually
docker compose -f docker-compose.prod.yaml run --rm -T \
  --entrypoint sh server \
  -c './server --mode=production --apply-migrations --role=maintenance'

# Full redeploy cycle
docker compose -f docker-compose.prod.yaml pull server
docker compose -f docker-compose.prod.yaml rm -fsv server
docker compose -f docker-compose.prod.yaml up -d server
```

## Backup / Restore

```bash
# Backup
docker compose -f docker-compose.prod.yaml exec -T postgres \
  pg_dump -U postgres gyanburu_fin > backup_$(date +%Y%m%d).sql

# Restore
docker compose -f docker-compose.prod.yaml exec -T postgres \
  psql -U postgres gyanburu_fin < backup_YYYYMMDD.sql
```

## Safety rules

- Always confirm with the user before running DELETE, UPDATE, DROP, or TRUNCATE.
- Always use `-T` (non-TTY) on `docker compose exec` calls.
- Never output `passwords.yaml` contents or secret environment variables.
- Prefer read-only queries first; only write when explicitly asked.
