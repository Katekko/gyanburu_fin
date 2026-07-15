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
    final userId = _userId(session);
    entry.userId = userId;
    final saved = await MonthlyEntry.db.insertRow(session, entry);

    if (saved.recurrent) {
      await _copyIntoMaterializedFutureMonths(session, userId, saved);
    }
    return saved;
  }

  Future<MonthlyEntry> update(
    Session session,
    MonthlyEntry entry,
  ) async {
    _validate(entry);
    final userId = _userId(session);
    entry.userId = userId;

    final before = await MonthlyEntry.db.findFirstRow(
      session,
      where: (t) => t.id.equals(entry.id) & t.userId.equals(userId),
    );
    if (before == null) throw Exception('Entry not found');

    final saved = await MonthlyEntry.db.updateRow(session, entry);

    if (before.recurrent) {
      await _propagateToFutureMonths(session, userId, before, saved);
    }
    return saved;
  }

  // Months materialize a snapshot of the prior month on first access, so a
  // month opened before an edit would otherwise keep the stale values
  // forever. Carries edits to a recurrent entry forward into every
  // already-materialized future month, matching by the pre-edit name so
  // renames follow too. Paid entries are left untouched, and no-op saves
  // (e.g. toggling confirmed) don't overwrite future months.
  Future<void> _propagateToFutureMonths(
    Session session,
    UuidValue userId,
    MonthlyEntry before,
    MonthlyEntry saved,
  ) async {
    final changed = before.name != saved.name ||
        before.categoryId != saved.categoryId ||
        before.amount != saved.amount ||
        before.variable != saved.variable ||
        before.dueDate != saved.dueDate;
    if (!changed) return;

    final future = await MonthlyEntry.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          (t.month > saved.month) &
          t.recurrent.equals(true) &
          t.paid.equals(false) &
          t.name.equals(before.name) &
          t.type.equals(before.type),
    );
    if (future.isEmpty) return;

    await MonthlyEntry.db.update(
      session,
      future
          .map((f) => f.copyWith(
                name: saved.name,
                categoryId: saved.categoryId,
                amount: saved.amount,
                variable: saved.variable,
                dueDate: _rollDueDate(saved.dueDate, f.month),
              ))
          .toList(),
    );
  }

  // A recurrent entry created in a month whose following months were already
  // materialized would never show up in them; insert the copies directly,
  // skipping months that already have an entry with the same name and type.
  Future<void> _copyIntoMaterializedFutureMonths(
    Session session,
    UuidValue userId,
    MonthlyEntry saved,
  ) async {
    final futureRows = await MonthlyEntry.db.find(
      session,
      where: (t) => t.userId.equals(userId) & (t.month > saved.month),
    );
    if (futureRows.isEmpty) return;

    final occupied = futureRows
        .where((f) => f.name == saved.name && f.type == saved.type)
        .map((f) => f.month)
        .toSet();
    final targetMonths = futureRows.map((f) => f.month).toSet()
      ..removeAll(occupied);
    if (targetMonths.isEmpty) return;

    await MonthlyEntry.db.insert(
      session,
      targetMonths
          .map((m) => MonthlyEntry(
                userId: userId,
                categoryId: saved.categoryId,
                name: saved.name,
                type: saved.type,
                amount: saved.amount,
                month: m,
                recurrent: true,
                variable: saved.variable,
                confirmed: !saved.variable,
                dueDate: _rollDueDate(saved.dueDate, m),
                paid: false,
              ))
          .toList(),
    );
  }

  Future<void> delete(Session session, int id) async {
    final userId = _userId(session);

    // Remove attached documents (storage files + rows) so nothing is orphaned
    // in cloud storage when the bill goes away.
    final attachments = await Attachment.db.find(
      session,
      where: (a) => a.entryId.equals(id) & a.userId.equals(userId),
    );
    for (final a in attachments) {
      await session.storage
          .deleteFile(storageId: 'private', path: a.storagePath);
    }
    if (attachments.isNotEmpty) {
      await Attachment.db.deleteWhere(
        session,
        where: (a) => a.entryId.equals(id) & a.userId.equals(userId),
      );
    }

    await MonthlyEntry.db.deleteWhere(
      session,
      where: (t) => t.id.equals(id) & t.userId.equals(userId),
    );
  }
}
