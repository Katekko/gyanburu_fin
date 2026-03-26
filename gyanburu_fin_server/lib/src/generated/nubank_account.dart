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
import 'account_type.dart' as _i2;
import 'sync_status.dart' as _i3;

abstract class NubankAccount
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  NubankAccount._({
    this.id,
    required this.userId,
    required this.accountType,
    this.lastSyncAt,
    required this.syncStatus,
    this.consentExpiresAt,
  });

  factory NubankAccount({
    int? id,
    required _i1.UuidValue userId,
    required _i2.AccountType accountType,
    DateTime? lastSyncAt,
    required _i3.SyncStatus syncStatus,
    DateTime? consentExpiresAt,
  }) = _NubankAccountImpl;

  factory NubankAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return NubankAccount(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      accountType: _i2.AccountType.fromJson(
        (jsonSerialization['accountType'] as String),
      ),
      lastSyncAt: jsonSerialization['lastSyncAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastSyncAt']),
      syncStatus: _i3.SyncStatus.fromJson(
        (jsonSerialization['syncStatus'] as String),
      ),
      consentExpiresAt: jsonSerialization['consentExpiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['consentExpiresAt'],
            ),
    );
  }

  static final t = NubankAccountTable();

  static const db = NubankAccountRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  _i2.AccountType accountType;

  DateTime? lastSyncAt;

  _i3.SyncStatus syncStatus;

  DateTime? consentExpiresAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [NubankAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NubankAccount copyWith({
    int? id,
    _i1.UuidValue? userId,
    _i2.AccountType? accountType,
    DateTime? lastSyncAt,
    _i3.SyncStatus? syncStatus,
    DateTime? consentExpiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NubankAccount',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'accountType': accountType.toJson(),
      if (lastSyncAt != null) 'lastSyncAt': lastSyncAt?.toJson(),
      'syncStatus': syncStatus.toJson(),
      if (consentExpiresAt != null)
        'consentExpiresAt': consentExpiresAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NubankAccount',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'accountType': accountType.toJson(),
      if (lastSyncAt != null) 'lastSyncAt': lastSyncAt?.toJson(),
      'syncStatus': syncStatus.toJson(),
      if (consentExpiresAt != null)
        'consentExpiresAt': consentExpiresAt?.toJson(),
    };
  }

  static NubankAccountInclude include() {
    return NubankAccountInclude._();
  }

  static NubankAccountIncludeList includeList({
    _i1.WhereExpressionBuilder<NubankAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NubankAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NubankAccountTable>? orderByList,
    NubankAccountInclude? include,
  }) {
    return NubankAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NubankAccount.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(NubankAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NubankAccountImpl extends NubankAccount {
  _NubankAccountImpl({
    int? id,
    required _i1.UuidValue userId,
    required _i2.AccountType accountType,
    DateTime? lastSyncAt,
    required _i3.SyncStatus syncStatus,
    DateTime? consentExpiresAt,
  }) : super._(
         id: id,
         userId: userId,
         accountType: accountType,
         lastSyncAt: lastSyncAt,
         syncStatus: syncStatus,
         consentExpiresAt: consentExpiresAt,
       );

  /// Returns a shallow copy of this [NubankAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NubankAccount copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    _i2.AccountType? accountType,
    Object? lastSyncAt = _Undefined,
    _i3.SyncStatus? syncStatus,
    Object? consentExpiresAt = _Undefined,
  }) {
    return NubankAccount(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      accountType: accountType ?? this.accountType,
      lastSyncAt: lastSyncAt is DateTime? ? lastSyncAt : this.lastSyncAt,
      syncStatus: syncStatus ?? this.syncStatus,
      consentExpiresAt: consentExpiresAt is DateTime?
          ? consentExpiresAt
          : this.consentExpiresAt,
    );
  }
}

class NubankAccountUpdateTable extends _i1.UpdateTable<NubankAccountTable> {
  NubankAccountUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<_i2.AccountType, _i2.AccountType> accountType(
    _i2.AccountType value,
  ) => _i1.ColumnValue(
    table.accountType,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastSyncAt(DateTime? value) =>
      _i1.ColumnValue(
        table.lastSyncAt,
        value,
      );

  _i1.ColumnValue<_i3.SyncStatus, _i3.SyncStatus> syncStatus(
    _i3.SyncStatus value,
  ) => _i1.ColumnValue(
    table.syncStatus,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> consentExpiresAt(DateTime? value) =>
      _i1.ColumnValue(
        table.consentExpiresAt,
        value,
      );
}

class NubankAccountTable extends _i1.Table<int?> {
  NubankAccountTable({super.tableRelation})
    : super(tableName: 'nubank_account') {
    updateTable = NubankAccountUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    accountType = _i1.ColumnEnum(
      'accountType',
      this,
      _i1.EnumSerialization.byName,
    );
    lastSyncAt = _i1.ColumnDateTime(
      'lastSyncAt',
      this,
    );
    syncStatus = _i1.ColumnEnum(
      'syncStatus',
      this,
      _i1.EnumSerialization.byName,
    );
    consentExpiresAt = _i1.ColumnDateTime(
      'consentExpiresAt',
      this,
    );
  }

  late final NubankAccountUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnEnum<_i2.AccountType> accountType;

  late final _i1.ColumnDateTime lastSyncAt;

  late final _i1.ColumnEnum<_i3.SyncStatus> syncStatus;

  late final _i1.ColumnDateTime consentExpiresAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    accountType,
    lastSyncAt,
    syncStatus,
    consentExpiresAt,
  ];
}

class NubankAccountInclude extends _i1.IncludeObject {
  NubankAccountInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => NubankAccount.t;
}

class NubankAccountIncludeList extends _i1.IncludeList {
  NubankAccountIncludeList._({
    _i1.WhereExpressionBuilder<NubankAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NubankAccount.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => NubankAccount.t;
}

class NubankAccountRepository {
  const NubankAccountRepository._();

  /// Returns a list of [NubankAccount]s matching the given query parameters.
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
  Future<List<NubankAccount>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NubankAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NubankAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NubankAccountTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NubankAccount>(
      where: where?.call(NubankAccount.t),
      orderBy: orderBy?.call(NubankAccount.t),
      orderByList: orderByList?.call(NubankAccount.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NubankAccount] matching the given query parameters.
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
  Future<NubankAccount?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NubankAccountTable>? where,
    int? offset,
    _i1.OrderByBuilder<NubankAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NubankAccountTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NubankAccount>(
      where: where?.call(NubankAccount.t),
      orderBy: orderBy?.call(NubankAccount.t),
      orderByList: orderByList?.call(NubankAccount.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NubankAccount] by its [id] or null if no such row exists.
  Future<NubankAccount?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NubankAccount>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NubankAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [NubankAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<NubankAccount>> insert(
    _i1.DatabaseSession session,
    List<NubankAccount> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<NubankAccount>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [NubankAccount] and returns the inserted row.
  ///
  /// The returned [NubankAccount] will have its `id` field set.
  Future<NubankAccount> insertRow(
    _i1.DatabaseSession session,
    NubankAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<NubankAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [NubankAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<NubankAccount>> update(
    _i1.DatabaseSession session,
    List<NubankAccount> rows, {
    _i1.ColumnSelections<NubankAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<NubankAccount>(
      rows,
      columns: columns?.call(NubankAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NubankAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NubankAccount> updateRow(
    _i1.DatabaseSession session,
    NubankAccount row, {
    _i1.ColumnSelections<NubankAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<NubankAccount>(
      row,
      columns: columns?.call(NubankAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NubankAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NubankAccount?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<NubankAccountUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<NubankAccount>(
      id,
      columnValues: columnValues(NubankAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NubankAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<NubankAccount>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<NubankAccountUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<NubankAccountTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NubankAccountTable>? orderBy,
    _i1.OrderByListBuilder<NubankAccountTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<NubankAccount>(
      columnValues: columnValues(NubankAccount.t.updateTable),
      where: where(NubankAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NubankAccount.t),
      orderByList: orderByList?.call(NubankAccount.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [NubankAccount]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<NubankAccount>> delete(
    _i1.DatabaseSession session,
    List<NubankAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<NubankAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [NubankAccount].
  Future<NubankAccount> deleteRow(
    _i1.DatabaseSession session,
    NubankAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NubankAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<NubankAccount>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<NubankAccountTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<NubankAccount>(
      where: where(NubankAccount.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NubankAccountTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<NubankAccount>(
      where: where?.call(NubankAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NubankAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<NubankAccountTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NubankAccount>(
      where: where(NubankAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
