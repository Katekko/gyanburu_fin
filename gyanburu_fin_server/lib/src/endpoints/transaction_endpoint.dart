import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/validation.dart';

class TransactionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Future<List<FinancialTransaction>> list(Session session) async {
    return FinancialTransaction.db.find(
      session,
      where: (t) => t.userId.equals(_userId(session)),
      orderBy: (t) => t.occurredAt,
      orderDescending: true,
    );
  }

  Future<List<FinancialTransaction>> listByMonth(
    Session session,
    DateTime month,
  ) async {
    final userId = _userId(session);
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);
    final key = '${month.year.toString().padLeft(4, '0')}-'
        '${month.month.toString().padLeft(2, '0')}';
    return FinancialTransaction.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          (t.billingMonth.equals(key) |
              (t.billingMonth.equals(null) &
                  t.occurredAt.between(start, end))),
      orderBy: (t) => t.occurredAt,
      orderDescending: true,
    );
  }

  void _validate(FinancialTransaction t) {
    Validate.requireString(t.merchantName, 'merchantName');
    Validate.requireFiniteAmount(t.amount, 'amount');
    Validate.requireString(t.currency, 'currency', maxLength: 10);
  }

  Future<FinancialTransaction> create(
    Session session,
    FinancialTransaction transaction,
  ) async {
    _validate(transaction);
    transaction.userId = _userId(session);
    return FinancialTransaction.db.insertRow(session, transaction);
  }

  Future<FinancialTransaction> update(
    Session session,
    FinancialTransaction transaction,
  ) async {
    _validate(transaction);
    transaction.userId = _userId(session);
    return FinancialTransaction.db.updateRow(session, transaction);
  }

  Future<void> delete(Session session, int id) async {
    await FinancialTransaction.db.deleteWhere(
      session,
      where: (t) =>
          t.id.equals(id) & t.userId.equals(_userId(session)),
    );
  }

  /// Applies an edit to a transaction and optionally propagates the
  /// category and display name to the CategoryRule plus all sibling
  /// transactions sharing the same merchant name.
  ///
  /// - Category always propagates to siblings and the rule.
  /// - Display name propagates only when [propagateDisplayName] is true;
  ///   otherwise the rule's displayName and siblings' displayName are
  ///   cleared so the user can set per-transaction names.
  Future<FinancialTransaction> saveWithPropagation(
    Session session,
    int transactionId,
    String? categoryName,
    String? displayName,
    bool propagateDisplayName,
  ) async {
    final userId = _userId(session);
    final tx = await FinancialTransaction.db.findById(session, transactionId);
    if (tx == null || tx.userId != userId) {
      throw ArgumentError('Transaction not found');
    }

    final effectiveCategory = (categoryName ?? '').trim();
    final effectiveDisplay =
        (displayName == null || displayName.trim().isEmpty)
            ? null
            : displayName.trim();

    tx.category = effectiveCategory;
    tx.displayName = effectiveDisplay;
    await FinancialTransaction.db.updateRow(session, tx);

    int? categoryId;
    if (effectiveCategory.isNotEmpty) {
      final cat = (await Category.db.find(
        session,
        where: (c) =>
            c.userId.equals(userId) & c.name.equals(effectiveCategory),
      ))
          .firstOrNull;
      categoryId = cat?.id;
    }

    final ruleDisplayName = propagateDisplayName ? effectiveDisplay : null;

    final existingRule = (await CategoryRule.db.find(
      session,
      where: (r) =>
          r.userId.equals(userId) &
          r.merchantPattern.equals(tx.merchantName),
    ))
        .firstOrNull;

    if (categoryId == null && ruleDisplayName == null) {
      if (existingRule != null) {
        await CategoryRule.db.deleteRow(session, existingRule);
      }
    } else if (existingRule != null) {
      existingRule.categoryId = categoryId;
      existingRule.displayName = ruleDisplayName;
      await CategoryRule.db.updateRow(session, existingRule);
    } else {
      await CategoryRule.db.insertRow(
        session,
        CategoryRule(
          userId: userId,
          merchantPattern: tx.merchantName,
          categoryId: categoryId,
          displayName: ruleDisplayName,
        ),
      );
    }

    final siblings = await FinancialTransaction.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.merchantName.equals(tx.merchantName) &
          t.id.notEquals(transactionId),
    );
    for (final sibling in siblings) {
      sibling.category = effectiveCategory;
      sibling.displayName =
          propagateDisplayName ? effectiveDisplay : null;
      await FinancialTransaction.db.updateRow(session, sibling);
    }

    return tx;
  }
}
