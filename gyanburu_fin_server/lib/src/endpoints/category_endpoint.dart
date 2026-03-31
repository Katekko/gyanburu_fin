import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/validation.dart';

class CategoryEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Future<List<Category>> list(Session session) async {
    return Category.db.find(
      session,
      where: (t) => t.userId.equals(_userId(session)),
    );
  }

  void _validate(Category c) {
    Validate.requireString(c.name, 'name');
    Validate.requireString(c.icon, 'icon');
    Validate.requireHexColor(c.color, 'color');
  }

  Future<Category> create(
    Session session,
    Category category,
  ) async {
    _validate(category);
    category.userId = _userId(session);
    return Category.db.insertRow(session, category);
  }

  Future<Category> update(
    Session session,
    Category category,
  ) async {
    _validate(category);
    category.userId = _userId(session);
    return Category.db.updateRow(session, category);
  }

  Future<void> delete(Session session, int id) async {
    await Category.db.deleteWhere(
      session,
      where: (t) =>
          t.id.equals(id) & t.userId.equals(_userId(session)),
    );
  }
}
