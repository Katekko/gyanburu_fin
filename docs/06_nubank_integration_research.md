# Nubank Integration Research

> Research date: 2026-03-31

## Goal

~~Sync Nubank financial data (transactions, balances, credit card bills) into gyanburu_fin automatically.~~

**Updated goal (2026-03-31):** Import Nubank OFX exports into gyanburu_fin. Nubank allows exporting credit card statements as OFX files. This is free, reliable, and superior to CSV for a personal project.

## Decision: OFX Import over API Sync

After researching all options, we decided on **OFX file import** because:
- Pluggy/Belvo start at R$2,500/month — way too expensive for personal use
- No free tier exists for production (only sandbox with fake data)
- pynubank and all unofficial libraries are dead since Aug 2023
- Nubank OFX export is free and gives us more data than CSV

### Why OFX over CSV

| Feature | CSV | OFX |
|---------|-----|-----|
| Transaction ID (FITID) | No | Yes (UUID) — **bulletproof deduplication** |
| Transaction type | No | Yes (CREDIT/DEBIT) |
| Currency | No | Yes (CURDEF: BRL) |
| Account ID | No | Yes (ACCTID: UUID) |
| Statement balance | No | Yes (LEDGERBAL) |
| Statement period | No | Yes (DTSTART/DTEND) |
| Institution info | No | Yes (ORG, FID) |
| Merchant name | title field | MEMO field |
| Date | YYYY-MM-DD | YYYYMMDDHHMMSS with timezone |
| Amount sign | positive (negative=refund) | negative=debit, positive=credit |

### Nubank OFX Format

```ofx
OFXHEADER:100
DATA:OFXSGML
VERSION:102
...
<OFX>
  <CREDITCARDMSGSRSV1>
    <CCSTMTRS>
      <CURDEF>BRL</CURDEF>
      <CCACCTFROM>
        <ACCTID>5a259adc-20fd-415b-bdc1-a4166eccf11b</ACCTID>
      </CCACCTFROM>
      <BANKTRANLIST>
        <DTSTART>20260331000000[-3:BRT]</DTSTART>
        <DTEND>20260430000000[-3:BRT]</DTEND>
        <STMTTRN>
          <TRNTYPE>DEBIT</TRNTYPE>
          <DTPOSTED>20260331000000[-3:BRT]</DTPOSTED>
          <TRNAMT>-175.40</TRNAMT>
          <FITID>69a8258f-dc2a-40a3-9036-39dbfe4be309</FITID>
          <MEMO>Mercadolivre*2produto - Parcela 2/10</MEMO>
        </STMTTRN>
        ...
      </BANKTRANLIST>
      <LEDGERBAL>
        <BALAMT>-1881.94</BALAMT>
        <DTASOF>20260430000000[-3:BRT]</DTASOF>
      </LEDGERBAL>
    </CCSTMTRS>
  </CREDITCARDMSGSRSV1>
</OFX>
```

**Key fields per transaction:**
- **TRNTYPE**: `CREDIT` (payment received) or `DEBIT` (charge)
- **DTPOSTED**: `YYYYMMDDHHMMSS[-3:BRT]` — date with timezone
- **TRNAMT**: signed amount (negative = expense, positive = income/payment)
- **FITID**: UUID — unique transaction ID from Nubank (dedup key)
- **MEMO**: merchant name / description (includes installment info like `Parcela X/Y`)

---

## 1. Does Nubank Have a Public API?

**No.** Nubank does not offer any official public API for third-party developers. There is no developer portal, no API keys program, and no documented endpoints for reading account data. They have a NuPay for Business API (merchant payments), but nothing for reading user financial data.

---

## 2. Open Finance Brasil (Regulated by Central Bank)

Open Finance Brasil is regulated by BCB (Banco Central do Brasil). Nubank is a full participant and exposes standardized APIs for accounts, transactions, credit cards, loans, investments, etc.

### How it works
- Only **BCB-authorized institutions** can be data receivers
- User must give explicit consent (OAuth-like redirect flow to Nubank)
- Secured with mTLS, FAPI security profile, OpenID Connect

### What data is available
- Accounts (balances, transactions)
- Credit cards (bills, transactions, limits)
- Loans, investments, insurance, pension, foreign exchange

### The catch
- **You cannot access Open Finance APIs as an individual developer or small project**
- Requires BCB registration, compliance certification, and significant infrastructure
- Designed for institution-to-institution data sharing

### Useful links
- https://nubank.com.br/nu/open-finance-nubank
- https://building.nubank.com/building-open-finance-at-nubank/
- https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages
- https://openfinancebrasil.org.br/modelo-de-participacao/

**Verdict:** The "right" way, but only viable through an aggregator (see below).

---

## 3. Third-Party Aggregators (Most Practical Option)

These are BCB-authorized companies that already did the compliance work and expose simplified APIs to developers.

### a) Pluggy (pluggy.ai)

- **Best option for Brazil-focused apps**
- Unified API for Open Finance Brasil
- Supports 90%+ of Brazilian banks including Nubank
- **Data:** Balances, transactions (categorized), credit cards, limits, installments, investments
- **How it works:** Embed Pluggy Connect Widget -> user authenticates via Open Finance consent -> data flows through standardized model (Items, Accounts, Transactions)
- **Pricing:** 14-day free trial. Paid plans after (contact sales). Free sandbox for dev.
- **SDKs:** JavaScript/Node.js, Python, REST API
- **Open source reference:** [MeuPluggy](https://github.com/pluggyai/meu-pluggy) - consumer app demonstrating consent & data management
- **Also used by:** [Actual Budget](https://actualbudget.org/docs/advanced/bank-sync/pluggyai/) for bank sync
- **Docs:** https://docs.pluggy.ai/

### b) Belvo (belvo.com)

- Open Finance Data Aggregation for Brazil and Latin America
- **Data:** Account owner info, accounts, credit cards, transactions (with categories), loans
- **How it works:** Embed Hosted Widget -> user consents -> async data loading -> webhook notifications
- **Nubank:** Explicitly listed as supported
- **Pricing:** Pay-per-API-call (like Twilio). Free sandbox. Production requires sales contact.
- **Docs:** https://developers.belvo.com/products/aggregation_brazil/aggregation-brazil-introduction

### Comparison

| Feature | Pluggy | Belvo |
|---------|--------|-------|
| Brazil focus | Primary market | Brazil + LatAm |
| Free tier | 14-day trial + sandbox | Sandbox only |
| Nubank support | Yes | Yes |
| SDK languages | JS, Python, REST | JS, Python, Ruby, REST |
| Open source reference | MeuPluggy | No |

---

## 4. Free / Open-Source Options

| Option | Status | Notes |
|--------|--------|-------|
| **MeuPluggy** | Active | Open-source app by Pluggy. Free dev account with limits. Daily data refresh. |
| **Pluggy Sandbox** | Active | 14-day free trial. Test connectors for development. |
| **Belvo Sandbox** | Active | Free sandbox (not production). |
| **Actual Budget + Pluggy** | Active | Open-source budgeting tool with Pluggy integration. Good reference implementation. |

**There is no fully free, production-ready solution** for accessing Nubank data.

---

## 5. Unofficial Methods (pynubank, etc.)

### pynubank (github.com/andreroggeri/pynubank)

- **STATUS: DEAD since August 2023**
- Nubank implemented mandatory facial verification (liveness check) for API auth
- Completely broke pynubank and all similar libraries
- All related projects are also dead: nubank-api (Node.js), nubank-client (JS), NubankPHP

### Risks (even if they worked)
- Account blocking by Nubank
- Terms of Service violation
- Security risk (sharing credentials)
- Fragile (any app update breaks it)
- Potential legal issues

**Verdict:** Not viable.

---

## 6. Summary

| Approach | Viable? | Cost | Effort | Risk |
|----------|---------|------|--------|------|
| Nubank Official API | No (doesn't exist) | - | - | - |
| Open Finance Direct | Only for BCB-authorized institutions | Very High | Very High | Low |
| **Pluggy** | **Yes** | **Paid (trial available)** | **Low-Medium** | **Low** |
| **Belvo** | **Yes** | **Paid (sandbox free)** | **Low-Medium** | **Low** |
| MeuPluggy free tier | Partially | Free with limits | Low | Low |
| pynubank / unofficial | No (broken since 2023) | - | - | Very High |

---

## 7. Architecture: OFX Import

```
User exports OFX from Nubank app
         |
         v
Flutter App (file picker) --> Serverpod Backend --> PostgreSQL
                                   |
                            1. Parse OFX (SGML)
                            2. Skip CREDIT transactions
                            3. Parse merchant name + installments
                            4. Dedup by FITID
                            5. Auto-categorize via CategoryRule
                            6. Store as FinancialTransaction
                            7. Log import in ImportHistory
```

### Import Flow (Final)
1. User exports OFX file from Nubank app
2. User taps "Import OFX" in gyanburu_fin
3. File picker -> select `.ofx` file
4. File sent to Serverpod backend
5. Backend parses OFX:
   - **Skip** all `CREDIT` transactions (bill payments)
   - **Parse MEMO**: extract clean merchant name + installment info (`Parcela X/Y`)
   - **Dedup** by FITID — skip if already in DB
   - **Auto-categorize** — check `CategoryRule` table for matching merchant name
   - **Insert** new `FinancialTransaction` records
   - **Log** import in `ImportHistory`
6. App shows result: "Imported X new transactions, Y skipped (duplicates)"

### Data Mapping: OFX -> FinancialTransaction

| OFX Field | FinancialTransaction Field | Notes |
|-----------|---------------------------|-------|
| MEMO | merchantName | Cleaned: strip `- Parcela X/Y` suffix |
| MEMO | installmentCurrent (new) | Parsed from `Parcela X/Y` (nullable) |
| MEMO | installmentTotal (new) | Parsed from `Parcela X/Y` (nullable) |
| TRNAMT | amount | Absolute value (we only import debits) |
| DTPOSTED | occurredAt | Parse `YYYYMMDDHHMMSS[-3:BRT]` |
| CURDEF | currency | `BRL` |
| FITID | externalId (new) | UUID string — deduplication key |
| ACCTID | nubankAccountId | Link to NubankAccount |

### Merchant Name Parsing Examples

| Raw MEMO | merchantName | installmentCurrent | installmentTotal |
|----------|-------------|-------------------|-----------------|
| `Msc Cruzeiros - Parcela 9/12` | `Msc Cruzeiros` | `9` | `12` |
| `Steamgames.Com` | `Steamgames.Com` | `null` | `null` |
| `IOF de "Steamgames.Com"` | `IOF de "Steamgames.Com"` | `null` | `null` |
| `Pichau Informatica - NuPay - Parcela 9/15` | `Pichau Informatica - NuPay` | `9` | `15` |

### Auto-Categorization via CategoryRule

When a user manually categorizes a transaction, a `CategoryRule` is created:

```
CategoryRule
  - userId: UuidValue
  - merchantPattern: String   (cleaned merchant name, e.g. "Msc Cruzeiros")
  - categoryId: int           (FK to Category)
```

**How it works:**
1. User imports transactions -> some come in uncategorized
2. User manually assigns category to a transaction (e.g. `Msc Cruzeiros` -> `Travel`)
3. System saves a `CategoryRule`: `"Msc Cruzeiros" -> Travel`
4. Next import: `Msc Cruzeiros - Parcela 10/12` arrives -> cleaned name matches rule -> auto-categorized as `Travel`
5. Works for all merchants: `IOF de "Steamgames.Com"` -> `IOF`, `Steamgames.Com` -> `Games`, etc.

**Matching:** exact match on cleaned merchant name. Can evolve to fuzzy/pattern matching later.

### Import History

Track every import for reference:

```
ImportHistory
  - userId: UuidValue
  - importedAt: DateTime
  - fileName: String           (e.g. "Nubank_2026-05-07.ofx")
  - statementStart: DateTime   (from OFX DTSTART)
  - statementEnd: DateTime     (from OFX DTEND)
  - totalTransactions: int     (total parsed from file)
  - newTransactions: int       (actually inserted)
  - skippedDuplicates: int     (skipped by FITID dedup)
  - skippedCredits: int        (skipped CREDIT transactions)
```

---

## 8. Decisions Made

- [x] **OFX over CSV** — more data, unique FITID for dedup
- [x] **No preview step** — import directly, show results
- [x] **Skip CREDIT transactions** — bill payments not needed
- [x] **Store FITID as `externalId`** — bulletproof dedup
- [x] **Parse installments** — `Parcela X/Y` into `installmentCurrent`/`installmentTotal`
- [x] **Auto-categorize by merchant** — `CategoryRule` table, exact match on cleaned merchant name
- [x] **Import history** — track every import with stats

---

## 9. New Models Needed

1. **FinancialTransaction** (update existing):
   - Add `externalId: String?` — FITID from OFX
   - Add `installmentCurrent: int?` — e.g. 9
   - Add `installmentTotal: int?` — e.g. 12

2. **CategoryRule** (new):
   - `userId: UuidValue`
   - `merchantPattern: String`
   - `categoryId: int`

3. **ImportHistory** (new):
   - `userId: UuidValue`
   - `importedAt: DateTime`
   - `fileName: String`
   - `statementStart: DateTime`
   - `statementEnd: DateTime`
   - `totalTransactions: int`
   - `newTransactions: int`
   - `skippedDuplicates: int`
   - `skippedCredits: int`

---

## 10. Next Steps

1. **Update `FinancialTransaction` model** — add `externalId`, `installmentCurrent`, `installmentTotal`
2. **Create `CategoryRule` model** + endpoint
3. **Create `ImportHistory` model** + endpoint
4. **Build OFX parser** on Serverpod backend
5. **Create import endpoint** — parse, dedup, auto-categorize, insert, log
6. **Build Flutter import UI** — file picker + result summary
7. **Build category assignment UI** — when user categorizes a transaction, offer to create a CategoryRule
8. **Run migration** and test with real Nubank OFX file
