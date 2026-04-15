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
}
