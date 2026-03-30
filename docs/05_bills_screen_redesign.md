# Bills Screen Redesign

## The Problem

Today the system has **two separate concepts** for the same thing:

- **MonthlyEntry** (expenses) — where you plan and register your monthly costs (energy, rent, internet...)
- **Bill** — a completely separate table with its own CRUD, disconnected from MonthlyEntry

This means if you register "Energy - R$180" as a monthly expense, and then go to Bills to track payment, you'd have to register it **again**. Double entry, double maintenance, data out of sync.

## The Core Idea

**Bills are not a separate entity. Bills are the "payment layer" on top of your existing expenses.**

You already registered "Energy R$180" in Monthly Overview. The Bills screen should:

1. **Pull from your existing expenses** (MonthlyEntry where type = expense)
2. Let you **manage the payment workflow** for each one
3. Track **what's paid, what's pending, what's overdue**
4. Attach **payment documents** (boleto PDF, PIX code, barcode, bank slip photo)
5. Give you a **clear view of "what do I still need to pay this month?"**

---

## How It Should Work (User Flow)

### Scenario: "Tomorrow is payday, time to pay bills"

1. Open **Bills** screen
2. See all your expenses for the current month, pulled from MonthlyEntry
3. Each expense shows: name, amount, category, due date, payment status
4. Filter/sort by: pending first, due date, amount
5. Tap an expense to open the **payment detail**
6. Attach the boleto PDF or paste the barcode/PIX code
7. When you pay it, tap **"Mark as Paid"**
8. Optionally record: payment date, payment method, actual amount paid (if different)
9. The expense now shows as paid with a green checkmark

### Scenario: "What do I still owe this month?"

1. Open **Bills** screen
2. Glance at the summary bar: "R$1,200 pending / R$800 paid / R$2,000 total"
3. Pending items are highlighted at the top
4. Overdue items (past due date, not paid) show a red warning

---

## Data Model Changes

### Extend MonthlyEntry

Add payment-related fields directly to MonthlyEntry:

```yaml
class: MonthlyEntry
table: monthly_entry
fields:
  # --- existing fields ---
  userId: UuidValue
  categoryId: int
  name: String
  type: EntryType          # income | expense
  amount: double
  month: String            # "2026-03"
  recurrent: bool
  variable: bool
  confirmed: bool
  # --- new payment fields ---
  dueDate: DateTime?       # full date — bills don't always follow 5th/10th/15th
  paid: bool               # expense: "paid" / income: "received" (default false)
  paidAt: DateTime?        # when was it actually paid/received
  paidAmount: double?      # actual amount (may differ from planned)
  paymentMethod: String?   # "PIX", "Boleto", "Credit Card", "Debit Card", "Transfer", "Cash"
  paymentNote: String?     # free text note about the payment
```

**Why extend instead of a separate table:**
- No new tables, no joins, no sync problems
- The MonthlyEntry IS the bill — they're the same thing
- The three states are clear and independent:
  - `variable` — "this value changes month to month, check it"
  - `confirmed` — "the real value for this month is set"
  - `paid` — "the money actually moved"
- Simple queries: `WHERE type = 'expense' AND month = '2026-03' AND paid = false`
- Works for income too: `paid` means "received"
- No partial payments needed — one payment per entry is enough

---

## Payment Documents / Attachments

### The Problem

You need to store boletos (PDF), barcodes, PIX QR codes, or photos of bank slips. This is the most complex part.

### Option 1: Simple text fields (Start here)

```yaml
# Add to MonthlyEntry
  boletoCode: String?      # barcode digits (47-48 chars) or PIX copy-paste code
  documentUrl: String?     # URL or local path to attached file
```

- Boleto barcode: just a string of digits, user can paste it and copy when paying
- PIX: the "copy and paste" code is also just a string
- For actual file attachments (PDF, photo): store in Serverpod's file storage and save the URL

**This is the pragmatic starting point.** The user can:
- Paste the boleto barcode and copy it when going to pay
- Paste the PIX code and copy it when going to pay
- Attach a PDF/image that they can open later

### Option 2: Full attachment system (Future)

A separate `Attachment` table with file upload, preview thumbnails, multiple files per entry. Build this when Option 1 feels limiting.

---

## Bills Screen UI Design

### Layout

```
+----------------------------------------------------------+
| Bills                                          March 2026 |
|                                            [< month >]    |
+----------------------------------------------------------+
| Summary:  Pending R$1,200  |  Paid R$800  |  Total R$2,000|
| [========== progress bar: 40% paid ===========]           |
+----------------------------------------------------------+
|                                                           |
| PENDING (sorted by due date)                              |
| +-------------------------------------------------------+|
| | [!] Energy          Due: Mar 5   R$180.00   [Pay >]   ||
| | [!] Internet        Due: Mar 10  R$120.00   [Pay >]   ||
| | [ ] Gym             Due: Mar 15  R$89.90    [Pay >]   ||
| | [ ] Rent            Due: Mar 15  R$1,500.00 [Pay >]   ||
| +-------------------------------------------------------+|
|                                                           |
| PAID                                                      |
| +-------------------------------------------------------+|
| | [v] Spotify         Paid Mar 1  R$21.90               ||
| | [v] Netflix         Paid Mar 2  R$55.90               ||
| +-------------------------------------------------------+|
|                                                           |
+----------------------------------------------------------+
```

### When you tap an expense:

```
+------------------------------------------+
| Energy                           R$180.00 |
| Category: Utilities  |  Due: Mar 5       |
| Recurrent: Yes  |  Variable: Yes         |
+------------------------------------------+
| Payment Info                              |
|                                           |
| Boleto/PIX Code:                          |
| [________________________________] [Copy] |
|                                           |
| Attachment:                               |
| [+ Add document]  or  [boleto.pdf] [Open] |
|                                           |
| Payment Method:  [PIX v]                  |
| Notes: ________________________________   |
|                                           |
| [Mark as Paid]              [Cancel]      |
+------------------------------------------+
```

---

## What Happens to the Existing Bill Table?

**We remove it.** Or rather, we stop using it. The Bill model, BillEndpoint, and BillDetailScreen in their current form all get replaced.

The `dueAt` from Bill becomes `dueDate` on MonthlyEntry — a full `DateTime?` because bills don't always fall on predictable days (credit card due dates, irregular bills, etc.).

The `status` enum (pending/paid/overdue) becomes derived:
- `paid == true` -> Paid
- `paid == false && dueDate != null && today > dueDate` -> Overdue
- `paid == false` -> Pending

No need for a status field that can get out of sync.

The `paid` field works for both expenses ("paid") and income ("received"). Same concept: "has the money actually moved?"

---

## Implementation Phases

### Phase 1: Data model + basic payment tracking
- Add new fields to MonthlyEntry (`dueDate`, `paid`, `paidAt`, `paidAmount`, `paymentMethod`, `paymentNote`)
- Run Serverpod migration
- Update MonthlyEntry dialog to include `dueDay` field
- Build the new Bills screen that reads from MonthlyEntry (expenses only)
- Mark as paid functionality
- Summary bar (pending/paid/total)

### Phase 2: Payment documents
- Add `boletoCode` and `documentUrl` fields to MonthlyEntry
- Payment detail panel with copy-to-clipboard for boleto/PIX codes
- File attachment (upload PDF/image, store via Serverpod file storage)
- Document preview/open

### Phase 3: Polish
- Overdue detection and warnings
- Push to dashboard ("3 bills due this week")
- Payment history (for recurrent entries: show past months' payment dates)
- Sort/filter options (by due date, amount, status, category)

### Phase 4: Smart features (future)
- Auto-carry recurrent expenses to next month with payment fields reset
- Reminders/notifications for upcoming due dates
- Payment method statistics ("you pay R$X via PIX, R$Y via boleto")

---

## Decisions Made

1. **Due date:** Full `DateTime?` — not just day-of-month. Bills don't follow neat patterns.

2. **Income payments:** Yes. The `paid` field means "received" for income entries. Same workflow: "my salary is planned but hasn't arrived yet."

3. **Three independent states:**
   - `variable` — "this value changes month to month, I should check it next month"
   - `confirmed` — "I verified the real value for this month"
   - `paid` — "the money actually moved (paid for expenses, received for income)"
   - A bill can be confirmed but not paid. A fixed bill can be paid without needing confirmation.

4. **Existing Bill data:** No real data exists in the bill table. Only MonthlyEntry has real data. Bill table/endpoint/screen will be replaced.

5. **Payment methods:** Hardcoded list: PIX, Boleto, Credit Card, Debit Card, Transfer, Cash.

6. **Multiple payments:** Not supported. One payment per entry. Keep it simple.
