import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class MonthlyEntryEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Future<List<MonthlyEntry>> listByMonth(
    Session session,
    String month,
  ) async {
    return MonthlyEntry.db.find(
      session,
      where: (t) =>
          t.userId.equals(_userId(session)) & t.month.equals(month),
    );
  }

  Future<MonthlyEntry> create(
    Session session,
    MonthlyEntry entry,
  ) async {
    entry.userId = _userId(session);
    return MonthlyEntry.db.insertRow(session, entry);
  }

  Future<MonthlyEntry> update(
    Session session,
    MonthlyEntry entry,
  ) async {
    return MonthlyEntry.db.updateRow(session, entry);
  }

  Future<void> delete(Session session, int id) async {
    await MonthlyEntry.db.deleteWhere(
      session,
      where: (t) => t.id.equals(id),
    );
  }
}
