---
applyTo: "**"
---

# Production access — gyanburu_fin

The production server runs in a Proxmox LXC reachable only via Tailscale.

## SSH

```bash
ssh <SERVER_USER>@<SERVER_HOST>
cd /opt/gyanburu_fin/gyanburu_fin_server
```

Credentials are stored as GitHub Actions secrets (`SERVER_USER`, `SERVER_HOST`,
`DEPLOY_SSH_KEY`). Full access guide: `docs/08_production_access.md`.

## Database (Postgres)

```bash
# Interactive shell
docker compose -f docker-compose.prod.yaml exec postgres \
  psql -U postgres gyanburu_fin

# One-off query (non-interactive, safe for scripts)
docker compose -f docker-compose.prod.yaml exec -T postgres \
  psql -U postgres gyanburu_fin -c "<SQL>"
```

Column names are **camelCase quoted** in Postgres:
`"userId"`, `"merchantName"`, `"occurredAt"`, `"billingMonth"`, `"externalId"`, `"source"`, `"kind"`.

## Server logs & control

```bash
docker compose -f docker-compose.prod.yaml logs -f server       # live tail
docker compose -f docker-compose.prod.yaml restart server       # restart
docker compose -f docker-compose.prod.yaml rm -fsv server \
  && docker compose -f docker-compose.prod.yaml up -d server    # full cycle
```

## Apply migrations manually

```bash
docker compose -f docker-compose.prod.yaml run --rm -T \
  --entrypoint sh server \
  -c './server --mode=production --apply-migrations --role=maintenance'
```

Migrations are normally applied automatically by the GitHub Actions deploy
workflow on every push to `main`.

## Safety

- Always confirm with the user before running DELETE, UPDATE, DROP, or TRUNCATE.
- Use `-T` on all `docker compose exec` calls for non-interactive use.
- Never output `passwords.yaml` or secret env vars.
