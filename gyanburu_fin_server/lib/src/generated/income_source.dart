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
import 'income_type.dart' as _i2;

abstract class IncomeSource
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  IncomeSource._({
    this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.amount,
    required this.month,
  });

  factory IncomeSource({
    int? id,
    required _i1.UuidValue userId,
    required String name,
    required _i2.IncomeType type,
    required double amount,
    required DateTime month,
  }) = _IncomeSourceImpl;

  factory IncomeSource.fromJson(Map<String, dynamic> jsonSerialization) {
    return IncomeSource(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      name: jsonSerialization['name'] as String,
      type: _i2.IncomeType.fromJson((jsonSerialization['type'] as String)),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      month: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['month']),
    );
  }

  static final t = IncomeSourceTable();

  static const db = IncomeSourceRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  String name;

  _i2.IncomeType type;

  double amount;

  DateTime month;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [IncomeSource]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IncomeSource copyWith({
    int? id,
    _i1.UuidValue? userId,
    String? name,
    _i2.IncomeType? type,
    double? amount,
    DateTime? month,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IncomeSource',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'name': name,
      'type': type.toJson(),
      'amount': amount,
      'month': month.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IncomeSource',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'name': name,
      'type': type.toJson(),
      'amount': amount,
      'month': month.toJson(),
    };
  }

  static IncomeSourceInclude include() {
    return IncomeSourceInclude._();
  }

  static IncomeSourceIncludeList includeList({
    _i1.WhereExpressionBuilder<IncomeSourceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IncomeSourceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IncomeSourceTable>? orderByList,
    IncomeSourceInclude? include,
  }) {
    return IncomeSourceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IncomeSource.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(IncomeSource.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IncomeSourceImpl extends IncomeSource {
  _IncomeSourceImpl({
    int? id,
    required _i1.UuidValue userId,
    required String name,
    required _i2.IncomeType type,
    required double amount,
    required DateTime month,
  }) : super._(
         id: id,
         userId: userId,
         name: name,
         type: type,
         amount: amount,
         month: month,
       );

  /// Returns a shallow copy of this [IncomeSource]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IncomeSource copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? name,
    _i2.IncomeType? type,
    double? amount,
    DateTime? month,
  }) {
    return IncomeSource(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      month: month ?? this.month,
    );
  }
}

class IncomeSourceUpdateTable extends _i1.UpdateTable<IncomeSourceTable> {
  IncomeSourceUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<_i2.IncomeType, _i2.IncomeType> type(_i2.IncomeType value) =>
      _i1.ColumnValue(
        table.type,
        value,
      );

  _i1.ColumnValue<double, double> amount(double value) => _i1.ColumnValue(
    table.amount,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> month(DateTime value) => _i1.ColumnValue(
    table.month,
    value,
  );
}

class IncomeSourceTable extends _i1.Table<int?> {
  IncomeSourceTable({super.tableRelation}) : super(tableName: 'income_source') {
    updateTable = IncomeSourceUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    type = _i1.ColumnEnum(
      'type',
      this,
      _i1.EnumSerialization.byName,
    );
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    month = _i1.ColumnDateTime(
      'month',
      this,
    );
  }

  late final IncomeSourceUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString name;

  late final _i1.ColumnEnum<_i2.IncomeType> type;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnDateTime month;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    name,
    type,
    amount,
    month,
  ];
}

class IncomeSourceInclude extends _i1.IncludeObject {
  IncomeSourceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => IncomeSource.t;
}

class IncomeSourceIncludeList extends _i1.IncludeList {
  IncomeSourceIncludeList._({
    _i1.WhereExpressionBuilder<IncomeSourceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IncomeSource.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => IncomeSource.t;
}

class IncomeSourceRepository {
  const IncomeSourceRepository._();

  /// Returns a list of [IncomeSource]s matching the given query parameters.
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
  Future<List<IncomeSource>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<IncomeSourceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IncomeSourceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IncomeSourceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<IncomeSource>(
      where: where?.call(IncomeSource.t),
      orderBy: orderBy?.call(IncomeSource.t),
      orderByList: orderByList?.call(IncomeSource.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [IncomeSource] matching the given query parameters.
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
  Future<IncomeSource?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<IncomeSourceTable>? where,
    int? offset,
    _i1.OrderByBuilder<IncomeSourceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IncomeSourceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<IncomeSource>(
      where: where?.call(IncomeSource.t),
      orderBy: orderBy?.call(IncomeSource.t),
      orderByList: orderByList?.call(IncomeSource.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [IncomeSource] by its [id] or null if no such row exists.
  Future<IncomeSource?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<IncomeSource>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [IncomeSource]s in the list and returns the inserted rows.
  ///
  /// The returned [IncomeSource]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<IncomeSource>> insert(
    _i1.DatabaseSession session,
    List<IncomeSource> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<IncomeSource>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [IncomeSource] and returns the inserted row.
  ///
  /// The returned [IncomeSource] will have its `id` field set.
  Future<IncomeSource> insertRow(
    _i1.DatabaseSession session,
    IncomeSource row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<IncomeSource>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [IncomeSource]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<IncomeSource>> update(
    _i1.DatabaseSession session,
    List<IncomeSource> rows, {
    _i1.ColumnSelections<IncomeSourceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<IncomeSource>(
      rows,
      columns: columns?.call(IncomeSource.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IncomeSource]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IncomeSource> updateRow(
    _i1.DatabaseSession session,
    IncomeSource row, {
    _i1.ColumnSelections<IncomeSourceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<IncomeSource>(
      row,
      columns: columns?.call(IncomeSource.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IncomeSource] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<IncomeSource?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<IncomeSourceUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<IncomeSource>(
      id,
      columnValues: columnValues(IncomeSource.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [IncomeSource]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<IncomeSource>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<IncomeSourceUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<IncomeSourceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IncomeSourceTable>? orderBy,
    _i1.OrderByListBuilder<IncomeSourceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<IncomeSource>(
      columnValues: columnValues(IncomeSource.t.updateTable),
      where: where(IncomeSource.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IncomeSource.t),
      orderByList: orderByList?.call(IncomeSource.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [IncomeSource]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<IncomeSource>> delete(
    _i1.DatabaseSession session,
    List<IncomeSource> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<IncomeSource>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [IncomeSource].
  Future<IncomeSource> deleteRow(
    _i1.DatabaseSession session,
    IncomeSource row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IncomeSource>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<IncomeSource>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<IncomeSourceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<IncomeSource>(
      where: where(IncomeSource.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<IncomeSourceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<IncomeSource>(
      where: where?.call(IncomeSource.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [IncomeSource] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<IncomeSourceTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<IncomeSource>(
      where: where(IncomeSource.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
