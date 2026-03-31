import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/validation.dart';

class IncomeEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Future<List<IncomeSource>> listByMonth(
    Session session,
    DateTime month,
  ) async {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);
    return IncomeSource.db.find(
      session,
      where: (i) =>
          i.userId.equals(_userId(session)) &
          i.month.between(start, end),
    );
  }

  void _validate(IncomeSource s) {
    Validate.requireString(s.name, 'name');
    Validate.requirePositiveAmount(s.amount, 'amount');
  }

  Future<IncomeSource> create(
    Session session,
    IncomeSource source,
  ) async {
    _validate(source);
    source.userId = _userId(session);
    return IncomeSource.db.insertRow(session, source);
  }

  Future<IncomeSource> update(
    Session session,
    IncomeSource source,
  ) async {
    _validate(source);
    source.userId = _userId(session);
    return IncomeSource.db.updateRow(session, source);
  }

  Future<void> delete(Session session, int id) async {
    await IncomeSource.db.deleteWhere(
      session,
      where: (i) =>
          i.id.equals(id) & i.userId.equals(_userId(session)),
    );
  }
}
