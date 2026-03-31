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

abstract class FinancialTransaction
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  FinancialTransaction._({
    this.id,
    required this.userId,
    this.nubankAccountId,
    required this.merchantName,
    required this.category,
    required this.amount,
    required this.currency,
    required this.occurredAt,
    this.description,
    this.externalId,
    this.installmentCurrent,
    this.installmentTotal,
  });

  factory FinancialTransaction({
    int? id,
    required _i1.UuidValue userId,
    _i1.UuidValue? nubankAccountId,
    required String merchantName,
    required String category,
    required double amount,
    required String currency,
    required DateTime occurredAt,
    String? description,
    String? externalId,
    int? installmentCurrent,
    int? installmentTotal,
  }) = _FinancialTransactionImpl;

  factory FinancialTransaction.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return FinancialTransaction(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      nubankAccountId: jsonSerialization['nubankAccountId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['nubankAccountId'],
            ),
      merchantName: jsonSerialization['merchantName'] as String,
      category: jsonSerialization['category'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      currency: jsonSerialization['currency'] as String,
      occurredAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurredAt'],
      ),
      description: jsonSerialization['description'] as String?,
      externalId: jsonSerialization['externalId'] as String?,
      installmentCurrent: jsonSerialization['installmentCurrent'] as int?,
      installmentTotal: jsonSerialization['installmentTotal'] as int?,
    );
  }

  static final t = FinancialTransactionTable();

  static const db = FinancialTransactionRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  _i1.UuidValue? nubankAccountId;

  String merchantName;

  String category;

  double amount;

  String currency;

  DateTime occurredAt;

  String? description;

  String? externalId;

  int? installmentCurrent;

  int? installmentTotal;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [FinancialTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FinancialTransaction copyWith({
    int? id,
    _i1.UuidValue? userId,
    _i1.UuidValue? nubankAccountId,
    String? merchantName,
    String? category,
    double? amount,
    String? currency,
    DateTime? occurredAt,
    String? description,
    String? externalId,
    int? installmentCurrent,
    int? installmentTotal,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FinancialTransaction',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (nubankAccountId != null) 'nubankAccountId': nubankAccountId?.toJson(),
      'merchantName': merchantName,
      'category': category,
      'amount': amount,
      'currency': currency,
      'occurredAt': occurredAt.toJson(),
      if (description != null) 'description': description,
      if (externalId != null) 'externalId': externalId,
      if (installmentCurrent != null) 'installmentCurrent': installmentCurrent,
      if (installmentTotal != null) 'installmentTotal': installmentTotal,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FinancialTransaction',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (nubankAccountId != null) 'nubankAccountId': nubankAccountId?.toJson(),
      'merchantName': merchantName,
      'category': category,
      'amount': amount,
      'currency': currency,
      'occurredAt': occurredAt.toJson(),
      if (description != null) 'description': description,
      if (externalId != null) 'externalId': externalId,
      if (installmentCurrent != null) 'installmentCurrent': installmentCurrent,
      if (installmentTotal != null) 'installmentTotal': installmentTotal,
    };
  }

  static FinancialTransactionInclude include() {
    return FinancialTransactionInclude._();
  }

  static FinancialTransactionIncludeList includeList({
    _i1.WhereExpressionBuilder<FinancialTransactionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FinancialTransactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FinancialTransactionTable>? orderByList,
    FinancialTransactionInclude? include,
  }) {
    return FinancialTransactionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FinancialTransaction.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FinancialTransaction.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FinancialTransactionImpl extends FinancialTransaction {
  _FinancialTransactionImpl({
    int? id,
    required _i1.UuidValue userId,
    _i1.UuidValue? nubankAccountId,
    required String merchantName,
    required String category,
    required double amount,
    required String currency,
    required DateTime occurredAt,
    String? description,
    String? externalId,
    int? installmentCurrent,
    int? installmentTotal,
  }) : super._(
         id: id,
         userId: userId,
         nubankAccountId: nubankAccountId,
         merchantName: merchantName,
         category: category,
         amount: amount,
         currency: currency,
         occurredAt: occurredAt,
         description: description,
         externalId: externalId,
         installmentCurrent: installmentCurrent,
         installmentTotal: installmentTotal,
       );

  /// Returns a shallow copy of this [FinancialTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FinancialTransaction copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? nubankAccountId = _Undefined,
    String? merchantName,
    String? category,
    double? amount,
    String? currency,
    DateTime? occurredAt,
    Object? description = _Undefined,
    Object? externalId = _Undefined,
    Object? installmentCurrent = _Undefined,
    Object? installmentTotal = _Undefined,
  }) {
    return FinancialTransaction(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      nubankAccountId: nubankAccountId is _i1.UuidValue?
          ? nubankAccountId
          : this.nubankAccountId,
      merchantName: merchantName ?? this.merchantName,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      occurredAt: occurredAt ?? this.occurredAt,
      description: description is String? ? description : this.description,
      externalId: externalId is String? ? externalId : this.externalId,
      installmentCurrent: installmentCurrent is int?
          ? installmentCurrent
          : this.installmentCurrent,
      installmentTotal: installmentTotal is int?
          ? installmentTotal
          : this.installmentTotal,
    );
  }
}

class FinancialTransactionUpdateTable
    extends _i1.UpdateTable<FinancialTransactionTable> {
  FinancialTransactionUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> nubankAccountId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.nubankAccountId,
    value,
  );

  _i1.ColumnValue<String, String> merchantName(String value) => _i1.ColumnValue(
    table.merchantName,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<double, double> amount(double value) => _i1.ColumnValue(
    table.amount,
    value,
  );

  _i1.ColumnValue<String, String> currency(String value) => _i1.ColumnValue(
    table.currency,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> occurredAt(DateTime value) =>
      _i1.ColumnValue(
        table.occurredAt,
        value,
      );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> externalId(String? value) => _i1.ColumnValue(
    table.externalId,
    value,
  );

  _i1.ColumnValue<int, int> installmentCurrent(int? value) => _i1.ColumnValue(
    table.installmentCurrent,
    value,
  );

  _i1.ColumnValue<int, int> installmentTotal(int? value) => _i1.ColumnValue(
    table.installmentTotal,
    value,
  );
}

class FinancialTransactionTable extends _i1.Table<int?> {
  FinancialTransactionTable({super.tableRelation})
    : super(tableName: 'financial_transaction') {
    updateTable = FinancialTransactionUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    nubankAccountId = _i1.ColumnUuid(
      'nubankAccountId',
      this,
    );
    merchantName = _i1.ColumnString(
      'merchantName',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    currency = _i1.ColumnString(
      'currency',
      this,
    );
    occurredAt = _i1.ColumnDateTime(
      'occurredAt',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    externalId = _i1.ColumnString(
      'externalId',
      this,
    );
    installmentCurrent = _i1.ColumnInt(
      'installmentCurrent',
      this,
    );
    installmentTotal = _i1.ColumnInt(
      'installmentTotal',
      this,
    );
  }

  late final FinancialTransactionUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnUuid nubankAccountId;

  late final _i1.ColumnString merchantName;

  late final _i1.ColumnString category;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnString currency;

  late final _i1.ColumnDateTime occurredAt;

  late final _i1.ColumnString description;

  late final _i1.ColumnString externalId;

  late final _i1.ColumnInt installmentCurrent;

  late final _i1.ColumnInt installmentTotal;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    nubankAccountId,
    merchantName,
    category,
    amount,
    currency,
    occurredAt,
    description,
    externalId,
    installmentCurrent,
    installmentTotal,
  ];
}

class FinancialTransactionInclude extends _i1.IncludeObject {
  FinancialTransactionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => FinancialTransaction.t;
}

class FinancialTransactionIncludeList extends _i1.IncludeList {
  FinancialTransactionIncludeList._({
    _i1.WhereExpressionBuilder<FinancialTransactionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FinancialTransaction.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => FinancialTransaction.t;
}

class FinancialTransactionRepository {
  const FinancialTransactionRepository._();

  /// Returns a list of [FinancialTransaction]s matching the given query parameters.
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
  Future<List<FinancialTransaction>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FinancialTransactionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FinancialTransactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FinancialTransactionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FinancialTransaction>(
      where: where?.call(FinancialTransaction.t),
      orderBy: orderBy?.call(FinancialTransaction.t),
      orderByList: orderByList?.call(FinancialTransaction.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FinancialTransaction] matching the given query parameters.
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
  Future<FinancialTransaction?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FinancialTransactionTable>? where,
    int? offset,
    _i1.OrderByBuilder<FinancialTransactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FinancialTransactionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FinancialTransaction>(
      where: where?.call(FinancialTransaction.t),
      orderBy: orderBy?.call(FinancialTransaction.t),
      orderByList: orderByList?.call(FinancialTransaction.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FinancialTransaction] by its [id] or null if no such row exists.
  Future<FinancialTransaction?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FinancialTransaction>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FinancialTransaction]s in the list and returns the inserted rows.
  ///
  /// The returned [FinancialTransaction]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<FinancialTransaction>> insert(
    _i1.DatabaseSession session,
    List<FinancialTransaction> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<FinancialTransaction>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [FinancialTransaction] and returns the inserted row.
  ///
  /// The returned [FinancialTransaction] will have its `id` field set.
  Future<FinancialTransaction> insertRow(
    _i1.DatabaseSession session,
    FinancialTransaction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FinancialTransaction>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FinancialTransaction]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FinancialTransaction>> update(
    _i1.DatabaseSession session,
    List<FinancialTransaction> rows, {
    _i1.ColumnSelections<FinancialTransactionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FinancialTransaction>(
      rows,
      columns: columns?.call(FinancialTransaction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FinancialTransaction]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FinancialTransaction> updateRow(
    _i1.DatabaseSession session,
    FinancialTransaction row, {
    _i1.ColumnSelections<FinancialTransactionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FinancialTransaction>(
      row,
      columns: columns?.call(FinancialTransaction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FinancialTransaction] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FinancialTransaction?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<FinancialTransactionUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FinancialTransaction>(
      id,
      columnValues: columnValues(FinancialTransaction.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FinancialTransaction]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FinancialTransaction>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<FinancialTransactionUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<FinancialTransactionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FinancialTransactionTable>? orderBy,
    _i1.OrderByListBuilder<FinancialTransactionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FinancialTransaction>(
      columnValues: columnValues(FinancialTransaction.t.updateTable),
      where: where(FinancialTransaction.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FinancialTransaction.t),
      orderByList: orderByList?.call(FinancialTransaction.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FinancialTransaction]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FinancialTransaction>> delete(
    _i1.DatabaseSession session,
    List<FinancialTransaction> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FinancialTransaction>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FinancialTransaction].
  Future<FinancialTransaction> deleteRow(
    _i1.DatabaseSession session,
    FinancialTransaction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FinancialTransaction>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FinancialTransaction>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FinancialTransactionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FinancialTransaction>(
      where: where(FinancialTransaction.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FinancialTransactionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FinancialTransaction>(
      where: where?.call(FinancialTransaction.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FinancialTransaction] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FinancialTransactionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FinancialTransaction>(
      where: where(FinancialTransaction.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
