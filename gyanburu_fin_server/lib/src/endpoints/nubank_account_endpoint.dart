import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class NubankAccountEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Future<List<NubankAccount>> list(Session session) async {
    return NubankAccount.db.find(
      session,
      where: (a) => a.userId.equals(_userId(session)),
    );
  }

  Future<NubankAccount?> findById(Session session, int id) async {
    final account = await NubankAccount.db.findById(session, id);
    if (account == null || account.userId != _userId(session)) return null;
    return account;
  }

  Future<List<SyncLog>> syncLogs(Session session, int accountId) async {
    final account = await NubankAccount.db.findById(session, accountId);
    if (account == null || account.userId != _userId(session)) return [];
    return SyncLog.db.find(
      session,
      orderBy: (l) => l.syncedAt,
      orderDescending: true,
      limit: 20,
    );
  }
}
