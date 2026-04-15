# Plan: Fix Rule Propagation (Name + Category Independence)

## Overview

Currently, when a user edits a transaction, the **category always propagates** to all sibling transactions (same `merchantName`), and the **display name** only propagates if a checkbox is checked. This causes a problem: two Amazon transactions with the same merchant name but different intended categories (e.g., "Microwave" → Appliances, "Marmitex pots" → Kitchen) cannot have independent categories. Renaming one also overwrites the other when propagation is on.

The fix introduces **independent propagation control** for both display name and category, giving users per-transaction flexibility while keeping the convenience of bulk rules.

---

## Requirements

1. **Display name propagation** must remain controlled by its existing checkbox ("Apply this name to other X transactions").
2. **Category propagation** must get its own independent checkbox ("Apply this category to other X transactions").
3. When category propagation is **unchecked**, only the current transaction's category changes — siblings keep their current category, and the rule's `categoryId` is left as-is (or cleared if no display name rule exists either).
4. When category propagation is **checked**, the current behavior is preserved — all siblings and the rule get the same category.
5. The default state of the category checkbox should follow the same pattern as the display name checkbox:
   - New merchant (no rule): **checked** by default (propagate is the helpful default).
   - Existing rule with a `categoryId`: **checked** by default.
   - Existing rule without a `categoryId`: **unchecked** by default.
6. Both checkboxes should be visually grouped and clearly labeled.

---

## Implementation Steps

### Step 1 — Server: Update `saveWithPropagation` signature

**File:** `gyanburu_fin_server/lib/src/endpoints/transaction_endpoint.dart`

- Add a new parameter `bool propagateCategory` to `saveWithPropagation`.
- This controls whether the category is written to the rule and to sibling transactions.

### Step 2 — Server: Update propagation logic

**File:** `gyanburu_fin_server/lib/src/endpoints/transaction_endpoint.dart`

Update the body of `saveWithPropagation`:

- **Current transaction**: Always save both `category` and `displayName` on the edited transaction (no change here — the user's direct edit always applies to *this* transaction).
- **Rule management**:
  - Determine `ruleCategoryId` = `propagateCategory ? categoryId : existingRule?.categoryId` (preserve existing rule category if not propagating).
  - Determine `ruleDisplayName` = `propagateDisplayName ? effectiveDisplay : existingRule?.displayName` (same idea — preserve if not propagating). Wait — actually the current logic *clears* siblings' displayName when not propagating. We should keep that for displayName (existing behavior). But for category we should just not touch siblings.
  - Revised logic:
    - `ruleCategoryId`: If `propagateCategory` is true → use the new `categoryId`. If false → keep `existingRule?.categoryId` (don't touch the rule's category).
    - `ruleDisplayName`: If `propagateDisplayName` is true → use `effectiveDisplay`. If false → `null` (existing behavior — clear propagated name).
  - **Delete rule** only if both `ruleCategoryId` and `ruleDisplayName` end up null.
  - **Create/update rule** otherwise with the resolved values.
- **Sibling updates**:
  - Only update `sibling.category` if `propagateCategory` is true.
  - Only update `sibling.displayName` if `propagateDisplayName` is true (set to `effectiveDisplay`); if false, set to `null` (existing behavior).

### Step 3 — Client protocol: Regenerate

Run `serverpod generate` to regenerate the client protocol so the new `propagateCategory` parameter is available in `client.transaction.saveWithPropagation(...)`.

### Step 4 — Flutter: Update `_TransactionEditResult`

**File:** `gyanburu_fin_flutter/lib/screens/transaction_history_screen.dart`

- Add `bool propagateCategory` to the `_TransactionEditResult` class.

### Step 5 — Flutter: Update the edit dialog UI

**File:** `gyanburu_fin_flutter/lib/screens/transaction_history_screen.dart` (inside `_TransactionEditDialog`)

- Add a new state variable `_propagateCategory` (bool).
- Initialize it using the same pattern as `_propagateDisplayName`:
  - If `existingRule == null` → `true` (new merchant, default to propagate).
  - If `existingRule.categoryId != null` → `true` (rule already has category).
  - Otherwise → `false`.
- Pass `existingRule` (or at minimum `existingRule?.categoryId`) into the dialog so it can compute the default. Currently `existingRule?.displayName` is passed — extend this to also pass `existingRule?.categoryId` (or pass the whole rule object).
- Add a new `CheckboxListTile` below the category picker:
  - Label: **"Apply this category to other [merchantName] transactions"**
  - Bound to `_propagateCategory`.
- Return the new `propagateCategory` value in `_TransactionEditResult`.

### Step 6 — Flutter: Pass new param to server call

**File:** `gyanburu_fin_flutter/lib/screens/transaction_history_screen.dart` (inside `_showTransactionEditor`)

- Update the `client.transaction.saveWithPropagation(...)` call to include `result.propagateCategory`.

### Step 7 — Flutter: UX polish

- Group both checkboxes visually (e.g., under a small "Propagation" section divider or just keep them adjacent with consistent styling).
- Consider disabling the category propagation checkbox when no category is selected (since there's nothing to propagate).

---

## Testing

1. **Unit test (server):** Call `saveWithPropagation` with `propagateCategory=false` and `propagateDisplayName=false` — verify only the target transaction is modified, siblings are untouched, and the rule is not created/updated for those fields.
2. **Unit test (server):** Call with `propagateCategory=true` — verify all siblings get the new category and the rule's `categoryId` is updated.
3. **Unit test (server):** Call with `propagateDisplayName=true` and `propagateCategory=false` — verify siblings get the new displayName but keep their original category.
4. **Unit test (server):** Call with both false, then both true — verify rule lifecycle (create/update/delete) is correct.
5. **Integration test:** Two transactions with the same `merchantName`. Edit one with `propagateCategory=false`, assign category "Appliances". Edit the other with `propagateCategory=false`, assign category "Kitchen". Verify both keep their independent categories.
6. **UI test:** Open edit dialog for a merchant with an existing rule that has a `categoryId` — verify the category checkbox starts checked. Open for a merchant with no rule — verify it starts checked. Open for a merchant with a rule but no `categoryId` — verify it starts unchecked.
