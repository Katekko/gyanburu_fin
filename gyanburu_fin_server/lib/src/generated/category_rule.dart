/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class CategoryRule
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CategoryRule._({
    this.id,
    required this.userId,
    required this.merchantPattern,
    required this.categoryId,
    this.displayName,
  });

  factory CategoryRule({
    int? id,
    required _i1.UuidValue userId,
    required String merchantPattern,
    required int categoryId,
    String? displayName,
  }) = _CategoryRuleImpl;

  factory CategoryRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return CategoryRule(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      merchantPattern: jsonSerialization['merchantPattern'] as String,
      categoryId: jsonSerialization['categoryId'] as int,
      displayName: jsonSerialization['displayName'] as String?,
    );
  }

  static final t = CategoryRuleTable();

  static const db = CategoryRuleRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  String merchantPattern;

  int categoryId;

  String? displayName;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CategoryRule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CategoryRule copyWith({
    int? id,
    _i1.UuidValue? userId,
    String? merchantPattern,
    int? categoryId,
    String? displayName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CategoryRule',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'merchantPattern': merchantPattern,
      'categoryId': categoryId,
      if (displayName != null) 'displayName': displayName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CategoryRule',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'merchantPattern': merchantPattern,
      'categoryId': categoryId,
      if (displayName != null) 'displayName': displayName,
    };
  }

  static CategoryRuleInclude include() {
    return CategoryRuleInclude._();
  }

  static CategoryRuleIncludeList includeList({
    _i1.WhereExpressionBuilder<CategoryRuleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CategoryRuleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CategoryRuleTable>? orderByList,
    CategoryRuleInclude? include,
  }) {
    return CategoryRuleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CategoryRule.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CategoryRule.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CategoryRuleImpl extends CategoryRule {
  _CategoryRuleImpl({
    int? id,
    required _i1.UuidValue userId,
    required String merchantPattern,
    required int categoryId,
    String? displayName,
  }) : super._(
         id: id,
         userId: userId,
         merchantPattern: merchantPattern,
         categoryId: categoryId,
         displayName: displayName,
       );

  /// Returns a shallow copy of this [CategoryRule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CategoryRule copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? merchantPattern,
    int? categoryId,
    Object? displayName = _Undefined,
  }) {
    return CategoryRule(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      merchantPattern: merchantPattern ?? this.merchantPattern,
      categoryId: categoryId ?? this.categoryId,
      displayName: displayName is String? ? displayName : this.displayName,
    );
  }
}

class CategoryRuleUpdateTable extends _i1.UpdateTable<CategoryRuleTable> {
  CategoryRuleUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> merchantPattern(String value) =>
      _i1.ColumnValue(
        table.merchantPattern,
        value,
      );

  _i1.ColumnValue<int, int> categoryId(int value) => _i1.ColumnValue(
    table.categoryId,
    value,
  );

  _i1.ColumnValue<String, String> displayName(String? value) => _i1.ColumnValue(
    table.displayName,
    value,
  );
}

class CategoryRuleTable extends _i1.Table<int?> {
  CategoryRuleTable({super.tableRelation}) : super(tableName: 'category_rule') {
    updateTable = CategoryRuleUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    merchantPattern = _i1.ColumnString(
      'merchantPattern',
      this,
    );
    categoryId = _i1.ColumnInt(
      'categoryId',
      this,
    );
    displayName = _i1.ColumnString(
      'displayName',
      this,
    );
  }

  late final CategoryRuleUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString merchantPattern;

  late final _i1.ColumnInt categoryId;

  late final _i1.ColumnString displayName;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    merchantPattern,
    categoryId,
    displayName,
  ];
}

class CategoryRuleInclude extends _i1.IncludeObject {
  CategoryRuleInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CategoryRule.t;
}

class CategoryRuleIncludeList extends _i1.IncludeList {
  CategoryRuleIncludeList._({
    _i1.WhereExpressionBuilder<CategoryRuleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CategoryRule.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CategoryRule.t;
}

class CategoryRuleRepository {
  const CategoryRuleRepository._();

  /// Returns a list of [CategoryRule]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<CategoryRule>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CategoryRuleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CategoryRuleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CategoryRuleTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CategoryRule>(
      where: where?.call(CategoryRule.t),
      orderBy: orderBy?.call(CategoryRule.t),
      orderByList: orderByList?.call(CategoryRule.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CategoryRule] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<CategoryRule?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CategoryRuleTable>? where,
    int? offset,
    _i1.OrderByBuilder<CategoryRuleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CategoryRuleTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CategoryRule>(
      where: where?.call(CategoryRule.t),
      orderBy: orderBy?.call(CategoryRule.t),
      orderByList: orderByList?.call(CategoryRule.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CategoryRule] by its [id] or null if no such row exists.
  Future<CategoryRule?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CategoryRule>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CategoryRule]s in the list and returns the inserted rows.
  ///
  /// The returned [CategoryRule]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CategoryRule>> insert(
    _i1.DatabaseSession session,
    List<CategoryRule> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CategoryRule>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CategoryRule] and returns the inserted row.
  ///
  /// The returned [CategoryRule] will have its `id` field set.
  Future<CategoryRule> insertRow(
    _i1.DatabaseSession session,
    CategoryRule row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CategoryRule>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CategoryRule]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CategoryRule>> update(
    _i1.DatabaseSession session,
    List<CategoryRule> rows, {
    _i1.ColumnSelections<CategoryRuleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CategoryRule>(
      rows,
      columns: columns?.call(CategoryRule.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CategoryRule]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CategoryRule> updateRow(
    _i1.DatabaseSession session,
    CategoryRule row, {
    _i1.ColumnSelections<CategoryRuleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CategoryRule>(
      row,
      columns: columns?.call(CategoryRule.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CategoryRule] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CategoryRule?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CategoryRuleUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CategoryRule>(
      id,
      columnValues: columnValues(CategoryRule.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CategoryRule]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CategoryRule>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CategoryRuleUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CategoryRuleTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CategoryRuleTable>? orderBy,
    _i1.OrderByListBuilder<CategoryRuleTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CategoryRule>(
      columnValues: columnValues(CategoryRule.t.updateTable),
      where: where(CategoryRule.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CategoryRule.t),
      orderByList: orderByList?.call(CategoryRule.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CategoryRule]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CategoryRule>> delete(
    _i1.DatabaseSession session,
    List<CategoryRule> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CategoryRule>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CategoryRule].
  Future<CategoryRule> deleteRow(
    _i1.DatabaseSession session,
    CategoryRule row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CategoryRule>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CategoryRule>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CategoryRuleTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CategoryRule>(
      where: where(CategoryRule.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CategoryRuleTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CategoryRule>(
      where: where?.call(CategoryRule.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CategoryRule] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CategoryRuleTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CategoryRule>(
      where: where(CategoryRule.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
