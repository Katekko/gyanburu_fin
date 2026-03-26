import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class BudgetEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Future<List<BudgetCategory>> listByMonth(
    Session session,
    DateTime month,
  ) async {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);
    return BudgetCategory.db.find(
      session,
      where: (b) =>
          b.userId.equals(_userId(session)) &
          b.month.between(start, end),
    );
  }

  Future<BudgetCategory> create(
    Session session,
    BudgetCategory category,
  ) async {
    category.userId = _userId(session);
    return BudgetCategory.db.insertRow(session, category);
  }

  Future<BudgetCategory> update(
    Session session,
    BudgetCategory category,
  ) async {
    return BudgetCategory.db.updateRow(session, category);
  }

  Future<void> delete(Session session, int id) async {
    await BudgetCategory.db.deleteWhere(
      session,
      where: (b) => b.id.equals(id),
    );
  }
}
