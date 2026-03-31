import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class ImportHistoryEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Future<List<ImportHistory>> list(Session session) async {
    return ImportHistory.db.find(
      session,
      where: (h) => h.userId.equals(_userId(session)),
      orderBy: (h) => h.importedAt,
      orderDescending: true,
    );
  }
}
