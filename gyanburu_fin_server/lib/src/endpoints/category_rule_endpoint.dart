import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class CategoryRuleEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Future<List<CategoryRule>> list(Session session) async {
    return CategoryRule.db.find(
      session,
      where: (r) => r.userId.equals(_userId(session)),
    );
  }

  Future<CategoryRule> create(
    Session session,
    CategoryRule rule,
  ) async {
    rule.userId = _userId(session);
    return CategoryRule.db.insertRow(session, rule);
  }

  Future<CategoryRule> update(
    Session session,
    CategoryRule rule,
  ) async {
    return CategoryRule.db.updateRow(session, rule);
  }

  Future<void> delete(Session session, int id) async {
    await CategoryRule.db.deleteWhere(
      session,
      where: (r) => r.id.equals(id),
    );
  }
}
