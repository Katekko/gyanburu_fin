# Project Context — gyanburu_fin

## What is this?

A **personal finance management desktop app** that connects to Nubank via Open Finance.
The design was prototyped in Google Stitch (project ID: 5491582927741066688).

## Screens planned

| Screen | Description |
|--------|-------------|
| Dashboard | Net balance, spending donut chart, upcoming bills strip, recent transactions |
| Monthly Budget & Incomes | Budget categories with progress bars, income sources, month navigator |
| Transaction History | Filterable/grouped transaction table with expandable rows |
| Nubank Sync Status | Account connection cards, 7-day sync health, consent expiry, re-auth flow |
| Bill Detail | Merchant detail, payment history, mark-as-paid action |

## Design system

- **Theme:** "The Luminous Ledger" — dark editorial aesthetic
- **Primary:** Deep Purple `#6200EE`
- **Accent/Alert:** Vibrant Orange `#FF9800`
- **Headlines font:** Manrope
- **UI/data font:** Inter
- **Rule:** No 1px borders — use background tonal steps for hierarchy

## Planned data models (to implement)

```
User
  - id, name, avatarUrl, createdAt

NubankAccount
  - userId, accountType (checking/credit), lastSyncAt, syncStatus, consentExpiresAt

Transaction
  - userId, nubankAccountId, merchantName, category, amount, currency, occurredAt, description

BudgetCategory
  - userId, name, icon, limitAmount, month (YYYY-MM)

IncomeSource
  - userId, name, type (salary/freelance/investment), amount, month (YYYY-MM)

Bill
  - userId, merchantName, amount, dueAt, status (upcoming/paid/overdue), recurrent

SyncLog
  - nubankAccountId, syncedAt, status (ok/failed/skipped), errorMessage?
```

## Auth approach

Custom auth — no email/password or Serverpod IDP. Use `serverpod_auth_idp_server`
as a base and implement your own token-based flow (consistent with other projects
in this workspace that use a custom auth pattern).

## Nubank integration note

Open Finance Brazil provides a standardized API. The server will act as an
OAuth2 client: obtain consent, store tokens encrypted in the DB, and run
background `FutureCall` jobs to sync transactions periodically.
