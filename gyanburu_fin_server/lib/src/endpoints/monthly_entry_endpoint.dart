import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/validation.dart';

class MonthlyEntryEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Future<List<MonthlyEntry>> listByMonth(
    Session session,
    String month,
  ) async {
    Validate.requireMonthFormat(month, 'month');
    final userId = _userId(session);

    final existing = await MonthlyEntry.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.month.equals(month),
    );
    if (existing.isNotEmpty) return existing;

    // First time this month is opened: materialize recurrent entries from
    // the most recent prior month that has any.
    final latestPriorRecurrent = await MonthlyEntry.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          (t.month < month) &
          t.recurrent.equals(true),
      orderBy: (t) => t.month,
      orderDescending: true,
    );
    if (latestPriorRecurrent == null) return existing;

    final priorMonth = latestPriorRecurrent.month;
    final templates = await MonthlyEntry.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.month.equals(priorMonth) &
          t.recurrent.equals(true),
    );
    if (templates.isEmpty) return existing;

    final newEntries = templates
        .map((e) => MonthlyEntry(
              userId: userId,
              categoryId: e.categoryId,
              name: e.name,
              type: e.type,
              amount: e.amount,
              month: month,
              recurrent: true,
              variable: e.variable,
              confirmed: !e.variable,
              dueDate: _rollDueDate(e.dueDate, month),
              paid: false,
            ))
        .toList();

    return MonthlyEntry.db.insert(session, newEntries);
  }

  // Rolls a prior dueDate forward to the same day-of-month in [targetMonth],
  // clamping to the last day if the source day doesn't exist in the target
  // (e.g. Jan 31 -> Feb 28).
  DateTime? _rollDueDate(DateTime? prior, String targetMonth) {
    if (prior == null) return null;
    final parts = targetMonth.split('-');
    final year = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    final lastDay = DateTime(year, m + 1, 0).day;
    final day = prior.day > lastDay ? lastDay : prior.day;
    return DateTime(year, m, day, prior.hour, prior.minute, prior.second);
  }

  void _validate(MonthlyEntry e) {
    Validate.requireString(e.name, 'name');
    Validate.requirePositiveAmount(e.amount, 'amount');
    Validate.requireMonthFormat(e.month, 'month');
  }

  Future<MonthlyEntry> create(
    Session session,
    MonthlyEntry entry,
  ) async {
    _validate(entry);
    entry.userId = _userId(session);
    return MonthlyEntry.db.insertRow(session, entry);
  }

  Future<MonthlyEntry> update(
    Session session,
    MonthlyEntry entry,
  ) async {
    _validate(entry);
    entry.userId = _userId(session);
    return MonthlyEntry.db.updateRow(session, entry);
  }

  Future<void> delete(Session session, int id) async {
    await MonthlyEntry.db.deleteWhere(
      session,
      where: (t) =>
          t.id.equals(id) & t.userId.equals(_userId(session)),
    );
  }
}
