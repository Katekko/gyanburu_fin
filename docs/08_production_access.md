# Production Access

The server runs in a Proxmox LXC reachable only over Tailscale. All
commands below assume you are connected to the Tailscale network. SSH
key is the one registered in the `DEPLOY_SSH_KEY` GitHub secret.

---

## SSH into the server

```bash
ssh root@192.168.0.229
```

The app lives at `/opt/gyanburu_fin/gyanburu_fin_server`.

```bash
cd /opt/gyanburu_fin/gyanburu_fin_server
```

---

## Database (Postgres) in production

Postgres runs as a Docker container in the same Compose project.

### Open a psql shell

```bash
docker compose -f docker-compose.prod.yaml exec postgres \
  psql -U postgres gyanburu_fin
```

### One-off query without an interactive shell

```bash
docker compose -f docker-compose.prod.yaml exec -T postgres \
  psql -U postgres gyanburu_fin -c "SELECT COUNT(*) FROM financial_transaction;"
```

### Useful queries

```sql
-- Count transactions per user
SELECT "userId", COUNT(*), SUM(amount)
FROM financial_transaction
GROUP BY "userId";

-- Check applied migrations
SELECT module, version, timestamp FROM serverpod_migrations ORDER BY timestamp DESC;

-- Inspect category rules
SELECT "merchantPattern", "displayName", "categoryId" FROM category_rule;

-- Find un-classified bank transactions
SELECT id, "merchantName", amount, "occurredAt"
FROM financial_transaction
WHERE source = 'bank' AND category = '' AND kind = 'expense'
ORDER BY "occurredAt" DESC LIMIT 20;
```

---

## Server logs

```bash
# Live tail
docker compose -f docker-compose.prod.yaml logs -f server

# Last 200 lines
docker compose -f docker-compose.prod.yaml logs --tail=200 server
```

---

## Apply migrations manually

Normally handled by the deploy workflow, but if you need to run them
by hand:

```bash
docker compose -f docker-compose.prod.yaml run --rm -T \
  --entrypoint sh server \
  -c './server --mode=production --apply-migrations --role=maintenance'
```

---

## Restart the server

```bash
docker compose -f docker-compose.prod.yaml restart server
```

Full stop + start (picks up a new image if you already pulled):

```bash
docker compose -f docker-compose.prod.yaml rm -fsv server
docker compose -f docker-compose.prod.yaml up -d server
```

---

## Pull and deploy a new image by hand

```bash
docker compose -f docker-compose.prod.yaml pull server
docker compose -f docker-compose.prod.yaml rm -fsv server
docker compose -f docker-compose.prod.yaml up -d server
```

---

## Run an arbitrary Dart/Serverpod command inside the container

```bash
docker compose -f docker-compose.prod.yaml run --rm -T \
  --entrypoint sh server \
  -c '<your command here>'
```

---

## Backup Postgres data

```bash
docker compose -f docker-compose.prod.yaml exec -T postgres \
  pg_dump -U postgres gyanburu_fin > backup_$(date +%Y%m%d).sql
```

Restore:

```bash
docker compose -f docker-compose.prod.yaml exec -T postgres \
  psql -U postgres gyanburu_fin < backup_YYYYMMDD.sql
```
