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

abstract class BudgetCategory
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  BudgetCategory._({
    this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.limitAmount,
    required this.month,
  });

  factory BudgetCategory({
    int? id,
    required _i1.UuidValue userId,
    required String name,
    required String icon,
    required double limitAmount,
    required DateTime month,
  }) = _BudgetCategoryImpl;

  factory BudgetCategory.fromJson(Map<String, dynamic> jsonSerialization) {
    return BudgetCategory(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      name: jsonSerialization['name'] as String,
      icon: jsonSerialization['icon'] as String,
      limitAmount: (jsonSerialization['limitAmount'] as num).toDouble(),
      month: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['month']),
    );
  }

  static final t = BudgetCategoryTable();

  static const db = BudgetCategoryRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  String name;

  String icon;

  double limitAmount;

  DateTime month;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BudgetCategory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BudgetCategory copyWith({
    int? id,
    _i1.UuidValue? userId,
    String? name,
    String? icon,
    double? limitAmount,
    DateTime? month,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BudgetCategory',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'name': name,
      'icon': icon,
      'limitAmount': limitAmount,
      'month': month.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BudgetCategory',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'name': name,
      'icon': icon,
      'limitAmount': limitAmount,
      'month': month.toJson(),
    };
  }

  static BudgetCategoryInclude include() {
    return BudgetCategoryInclude._();
  }

  static BudgetCategoryIncludeList includeList({
    _i1.WhereExpressionBuilder<BudgetCategoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BudgetCategoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BudgetCategoryTable>? orderByList,
    BudgetCategoryInclude? include,
  }) {
    return BudgetCategoryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BudgetCategory.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BudgetCategory.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BudgetCategoryImpl extends BudgetCategory {
  _BudgetCategoryImpl({
    int? id,
    required _i1.UuidValue userId,
    required String name,
    required String icon,
    required double limitAmount,
    required DateTime month,
  }) : super._(
         id: id,
         userId: userId,
         name: name,
         icon: icon,
         limitAmount: limitAmount,
         month: month,
       );

  /// Returns a shallow copy of this [BudgetCategory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BudgetCategory copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? name,
    String? icon,
    double? limitAmount,
    DateTime? month,
  }) {
    return BudgetCategory(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      limitAmount: limitAmount ?? this.limitAmount,
      month: month ?? this.month,
    );
  }
}

class BudgetCategoryUpdateTable extends _i1.UpdateTable<BudgetCategoryTable> {
  BudgetCategoryUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> icon(String value) => _i1.ColumnValue(
    table.icon,
    value,
  );

  _i1.ColumnValue<double, double> limitAmount(double value) => _i1.ColumnValue(
    table.limitAmount,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> month(DateTime value) => _i1.ColumnValue(
    table.month,
    value,
  );
}

class BudgetCategoryTable extends _i1.Table<int?> {
  BudgetCategoryTable({super.tableRelation})
    : super(tableName: 'budget_category') {
    updateTable = BudgetCategoryUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    icon = _i1.ColumnString(
      'icon',
      this,
    );
    limitAmount = _i1.ColumnDouble(
      'limitAmount',
      this,
    );
    month = _i1.ColumnDateTime(
      'month',
      this,
    );
  }

  late final BudgetCategoryUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString icon;

  late final _i1.ColumnDouble limitAmount;

  late final _i1.ColumnDateTime month;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    name,
    icon,
    limitAmount,
    month,
  ];
}

class BudgetCategoryInclude extends _i1.IncludeObject {
  BudgetCategoryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BudgetCategory.t;
}

class BudgetCategoryIncludeList extends _i1.IncludeList {
  BudgetCategoryIncludeList._({
    _i1.WhereExpressionBuilder<BudgetCategoryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BudgetCategory.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BudgetCategory.t;
}

class BudgetCategoryRepository {
  const BudgetCategoryRepository._();

  /// Returns a list of [BudgetCategory]s matching the given query parameters.
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
  Future<List<BudgetCategory>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BudgetCategoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BudgetCategoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BudgetCategoryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BudgetCategory>(
      where: where?.call(BudgetCategory.t),
      orderBy: orderBy?.call(BudgetCategory.t),
      orderByList: orderByList?.call(BudgetCategory.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BudgetCategory] matching the given query parameters.
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
  Future<BudgetCategory?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BudgetCategoryTable>? where,
    int? offset,
    _i1.OrderByBuilder<BudgetCategoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BudgetCategoryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BudgetCategory>(
      where: where?.call(BudgetCategory.t),
      orderBy: orderBy?.call(BudgetCategory.t),
      orderByList: orderByList?.call(BudgetCategory.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BudgetCategory] by its [id] or null if no such row exists.
  Future<BudgetCategory?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BudgetCategory>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BudgetCategory]s in the list and returns the inserted rows.
  ///
  /// The returned [BudgetCategory]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<BudgetCategory>> insert(
    _i1.DatabaseSession session,
    List<BudgetCategory> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<BudgetCategory>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [BudgetCategory] and returns the inserted row.
  ///
  /// The returned [BudgetCategory] will have its `id` field set.
  Future<BudgetCategory> insertRow(
    _i1.DatabaseSession session,
    BudgetCategory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BudgetCategory>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BudgetCategory]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BudgetCategory>> update(
    _i1.DatabaseSession session,
    List<BudgetCategory> rows, {
    _i1.ColumnSelections<BudgetCategoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BudgetCategory>(
      rows,
      columns: columns?.call(BudgetCategory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BudgetCategory]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BudgetCategory> updateRow(
    _i1.DatabaseSession session,
    BudgetCategory row, {
    _i1.ColumnSelections<BudgetCategoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BudgetCategory>(
      row,
      columns: columns?.call(BudgetCategory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BudgetCategory] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BudgetCategory?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<BudgetCategoryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<BudgetCategory>(
      id,
      columnValues: columnValues(BudgetCategory.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BudgetCategory]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<BudgetCategory>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<BudgetCategoryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<BudgetCategoryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BudgetCategoryTable>? orderBy,
    _i1.OrderByListBuilder<BudgetCategoryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<BudgetCategory>(
      columnValues: columnValues(BudgetCategory.t.updateTable),
      where: where(BudgetCategory.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BudgetCategory.t),
      orderByList: orderByList?.call(BudgetCategory.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [BudgetCategory]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BudgetCategory>> delete(
    _i1.DatabaseSession session,
    List<BudgetCategory> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BudgetCategory>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BudgetCategory].
  Future<BudgetCategory> deleteRow(
    _i1.DatabaseSession session,
    BudgetCategory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BudgetCategory>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BudgetCategory>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BudgetCategoryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BudgetCategory>(
      where: where(BudgetCategory.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BudgetCategoryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BudgetCategory>(
      where: where?.call(BudgetCategory.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BudgetCategory] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BudgetCategoryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BudgetCategory>(
      where: where(BudgetCategory.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
