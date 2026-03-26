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
import 'sync_status.dart' as _i2;

abstract class SyncLog
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SyncLog._({
    this.id,
    required this.nubankAccountId,
    required this.syncedAt,
    required this.status,
    this.errorMessage,
  });

  factory SyncLog({
    int? id,
    required _i1.UuidValue nubankAccountId,
    required DateTime syncedAt,
    required _i2.SyncStatus status,
    String? errorMessage,
  }) = _SyncLogImpl;

  factory SyncLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return SyncLog(
      id: jsonSerialization['id'] as int?,
      nubankAccountId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['nubankAccountId'],
      ),
      syncedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['syncedAt'],
      ),
      status: _i2.SyncStatus.fromJson((jsonSerialization['status'] as String)),
      errorMessage: jsonSerialization['errorMessage'] as String?,
    );
  }

  static final t = SyncLogTable();

  static const db = SyncLogRepository._();

  @override
  int? id;

  _i1.UuidValue nubankAccountId;

  DateTime syncedAt;

  _i2.SyncStatus status;

  String? errorMessage;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SyncLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SyncLog copyWith({
    int? id,
    _i1.UuidValue? nubankAccountId,
    DateTime? syncedAt,
    _i2.SyncStatus? status,
    String? errorMessage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SyncLog',
      if (id != null) 'id': id,
      'nubankAccountId': nubankAccountId.toJson(),
      'syncedAt': syncedAt.toJson(),
      'status': status.toJson(),
      if (errorMessage != null) 'errorMessage': errorMessage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SyncLog',
      if (id != null) 'id': id,
      'nubankAccountId': nubankAccountId.toJson(),
      'syncedAt': syncedAt.toJson(),
      'status': status.toJson(),
      if (errorMessage != null) 'errorMessage': errorMessage,
    };
  }

  static SyncLogInclude include() {
    return SyncLogInclude._();
  }

  static SyncLogIncludeList includeList({
    _i1.WhereExpressionBuilder<SyncLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SyncLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SyncLogTable>? orderByList,
    SyncLogInclude? include,
  }) {
    return SyncLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SyncLog.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SyncLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SyncLogImpl extends SyncLog {
  _SyncLogImpl({
    int? id,
    required _i1.UuidValue nubankAccountId,
    required DateTime syncedAt,
    required _i2.SyncStatus status,
    String? errorMessage,
  }) : super._(
         id: id,
         nubankAccountId: nubankAccountId,
         syncedAt: syncedAt,
         status: status,
         errorMessage: errorMessage,
       );

  /// Returns a shallow copy of this [SyncLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SyncLog copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? nubankAccountId,
    DateTime? syncedAt,
    _i2.SyncStatus? status,
    Object? errorMessage = _Undefined,
  }) {
    return SyncLog(
      id: id is int? ? id : this.id,
      nubankAccountId: nubankAccountId ?? this.nubankAccountId,
      syncedAt: syncedAt ?? this.syncedAt,
      status: status ?? this.status,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
    );
  }
}

class SyncLogUpdateTable extends _i1.UpdateTable<SyncLogTable> {
  SyncLogUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> nubankAccountId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.nubankAccountId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> syncedAt(DateTime value) =>
      _i1.ColumnValue(
        table.syncedAt,
        value,
      );

  _i1.ColumnValue<_i2.SyncStatus, _i2.SyncStatus> status(
    _i2.SyncStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> errorMessage(String? value) =>
      _i1.ColumnValue(
        table.errorMessage,
        value,
      );
}

class SyncLogTable extends _i1.Table<int?> {
  SyncLogTable({super.tableRelation}) : super(tableName: 'sync_log') {
    updateTable = SyncLogUpdateTable(this);
    nubankAccountId = _i1.ColumnUuid(
      'nubankAccountId',
      this,
    );
    syncedAt = _i1.ColumnDateTime(
      'syncedAt',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
    );
    errorMessage = _i1.ColumnString(
      'errorMessage',
      this,
    );
  }

  late final SyncLogUpdateTable updateTable;

  late final _i1.ColumnUuid nubankAccountId;

  late final _i1.ColumnDateTime syncedAt;

  late final _i1.ColumnEnum<_i2.SyncStatus> status;

  late final _i1.ColumnString errorMessage;

  @override
  List<_i1.Column> get columns => [
    id,
    nubankAccountId,
    syncedAt,
    status,
    errorMessage,
  ];
}

class SyncLogInclude extends _i1.IncludeObject {
  SyncLogInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SyncLog.t;
}

class SyncLogIncludeList extends _i1.IncludeList {
  SyncLogIncludeList._({
    _i1.WhereExpressionBuilder<SyncLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SyncLog.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SyncLog.t;
}

class SyncLogRepository {
  const SyncLogRepository._();

  /// Returns a list of [SyncLog]s matching the given query parameters.
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
  Future<List<SyncLog>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SyncLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SyncLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SyncLogTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SyncLog>(
      where: where?.call(SyncLog.t),
      orderBy: orderBy?.call(SyncLog.t),
      orderByList: orderByList?.call(SyncLog.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SyncLog] matching the given query parameters.
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
  Future<SyncLog?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SyncLogTable>? where,
    int? offset,
    _i1.OrderByBuilder<SyncLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SyncLogTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SyncLog>(
      where: where?.call(SyncLog.t),
      orderBy: orderBy?.call(SyncLog.t),
      orderByList: orderByList?.call(SyncLog.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SyncLog] by its [id] or null if no such row exists.
  Future<SyncLog?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SyncLog>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SyncLog]s in the list and returns the inserted rows.
  ///
  /// The returned [SyncLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<SyncLog>> insert(
    _i1.DatabaseSession session,
    List<SyncLog> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<SyncLog>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [SyncLog] and returns the inserted row.
  ///
  /// The returned [SyncLog] will have its `id` field set.
  Future<SyncLog> insertRow(
    _i1.DatabaseSession session,
    SyncLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SyncLog>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SyncLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SyncLog>> update(
    _i1.DatabaseSession session,
    List<SyncLog> rows, {
    _i1.ColumnSelections<SyncLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SyncLog>(
      rows,
      columns: columns?.call(SyncLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SyncLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SyncLog> updateRow(
    _i1.DatabaseSession session,
    SyncLog row, {
    _i1.ColumnSelections<SyncLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SyncLog>(
      row,
      columns: columns?.call(SyncLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SyncLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SyncLog?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<SyncLogUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SyncLog>(
      id,
      columnValues: columnValues(SyncLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SyncLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SyncLog>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<SyncLogUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SyncLogTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SyncLogTable>? orderBy,
    _i1.OrderByListBuilder<SyncLogTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SyncLog>(
      columnValues: columnValues(SyncLog.t.updateTable),
      where: where(SyncLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SyncLog.t),
      orderByList: orderByList?.call(SyncLog.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SyncLog]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SyncLog>> delete(
    _i1.DatabaseSession session,
    List<SyncLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SyncLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SyncLog].
  Future<SyncLog> deleteRow(
    _i1.DatabaseSession session,
    SyncLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SyncLog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SyncLog>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SyncLogTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SyncLog>(
      where: where(SyncLog.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SyncLogTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SyncLog>(
      where: where?.call(SyncLog.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SyncLog] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SyncLogTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SyncLog>(
      where: where(SyncLog.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
