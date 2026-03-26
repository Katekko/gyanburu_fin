import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class BillEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Future<List<Bill>> list(Session session) async {
    return Bill.db.find(
      session,
      where: (b) => b.userId.equals(_userId(session)),
      orderBy: (b) => b.dueAt,
    );
  }

  Future<List<Bill>> listUpcoming(Session session) async {
    final now = DateTime.now();
    return Bill.db.find(
      session,
      where: (b) =>
          b.userId.equals(_userId(session)) &
          b.dueAt.between(now, now.add(const Duration(days: 30))) &
          b.status.equals(BillStatus.pending),
      orderBy: (b) => b.dueAt,
    );
  }

  Future<Bill> create(Session session, Bill bill) async {
    bill.userId = _userId(session);
    return Bill.db.insertRow(session, bill);
  }

  Future<Bill> update(Session session, Bill bill) async {
    return Bill.db.updateRow(session, bill);
  }

  Future<Bill> markAsPaid(Session session, int id) async {
    final bill = await Bill.db.findById(session, id);
    if (bill == null) throw Exception('Bill not found');
    bill.status = BillStatus.paid;
    return Bill.db.updateRow(session, bill);
  }

  Future<void> delete(Session session, int id) async {
    await Bill.db.deleteWhere(
      session,
      where: (b) => b.id.equals(id),
    );
  }
}
