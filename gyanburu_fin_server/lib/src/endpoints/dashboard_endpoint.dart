import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class DashboardEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Future<Map<String, double>> spendingByCategory(
    Session session,
    DateTime month,
  ) async {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);

    final transactions = await FinancialTransaction.db.find(
      session,
      where: (t) =>
          t.userId.equals(_userId(session)) &
          t.occurredAt.between(start, end) &
          t.amount.between(double.negativeInfinity, 0),
    );

    final Map<String, double> result = {};
    for (final t in transactions) {
      result[t.category] = (result[t.category] ?? 0) + t.amount.abs();
    }
    return result;
  }

  Future<List<FinancialTransaction>> recentTransactions(
    Session session,
  ) async {
    return FinancialTransaction.db.find(
      session,
      where: (t) => t.userId.equals(_userId(session)),
      orderBy: (t) => t.occurredAt,
      orderDescending: true,
      limit: 10,
    );
  }

  Future<double> netBalance(Session session, DateTime month) async {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);

    final transactions = await FinancialTransaction.db.find(
      session,
      where: (t) =>
          t.userId.equals(_userId(session)) &
          t.occurredAt.between(start, end),
    );

    double total = 0;
    for (final t in transactions) {
      total += t.amount;
    }
    return total;
  }
}
