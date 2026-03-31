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

abstract class ImportHistory
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ImportHistory._({
    this.id,
    required this.userId,
    required this.importedAt,
    required this.fileName,
    required this.statementStart,
    required this.statementEnd,
    required this.totalTransactions,
    required this.newTransactions,
    required this.skippedDuplicates,
    required this.skippedCredits,
  });

  factory ImportHistory({
    int? id,
    required _i1.UuidValue userId,
    required DateTime importedAt,
    required String fileName,
    required DateTime statementStart,
    required DateTime statementEnd,
    required int totalTransactions,
    required int newTransactions,
    required int skippedDuplicates,
    required int skippedCredits,
  }) = _ImportHistoryImpl;

  factory ImportHistory.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportHistory(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      importedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['importedAt'],
      ),
      fileName: jsonSerialization['fileName'] as String,
      statementStart: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['statementStart'],
      ),
      statementEnd: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['statementEnd'],
      ),
      totalTransactions: jsonSerialization['totalTransactions'] as int,
      newTransactions: jsonSerialization['newTransactions'] as int,
      skippedDuplicates: jsonSerialization['skippedDuplicates'] as int,
      skippedCredits: jsonSerialization['skippedCredits'] as int,
    );
  }

  static final t = ImportHistoryTable();

  static const db = ImportHistoryRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  DateTime importedAt;

  String fileName;

  DateTime statementStart;

  DateTime statementEnd;

  int totalTransactions;

  int newTransactions;

  int skippedDuplicates;

  int skippedCredits;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ImportHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ImportHistory copyWith({
    int? id,
    _i1.UuidValue? userId,
    DateTime? importedAt,
    String? fileName,
    DateTime? statementStart,
    DateTime? statementEnd,
    int? totalTransactions,
    int? newTransactions,
    int? skippedDuplicates,
    int? skippedCredits,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportHistory',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'importedAt': importedAt.toJson(),
      'fileName': fileName,
      'statementStart': statementStart.toJson(),
      'statementEnd': statementEnd.toJson(),
      'totalTransactions': totalTransactions,
      'newTransactions': newTransactions,
      'skippedDuplicates': skippedDuplicates,
      'skippedCredits': skippedCredits,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportHistory',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'importedAt': importedAt.toJson(),
      'fileName': fileName,
      'statementStart': statementStart.toJson(),
      'statementEnd': statementEnd.toJson(),
      'totalTransactions': totalTransactions,
      'newTransactions': newTransactions,
      'skippedDuplicates': skippedDuplicates,
      'skippedCredits': skippedCredits,
    };
  }

  static ImportHistoryInclude include() {
    return ImportHistoryInclude._();
  }

  static ImportHistoryIncludeList includeList({
    _i1.WhereExpressionBuilder<ImportHistoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ImportHistoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ImportHistoryTable>? orderByList,
    ImportHistoryInclude? include,
  }) {
    return ImportHistoryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ImportHistory.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ImportHistory.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImportHistoryImpl extends ImportHistory {
  _ImportHistoryImpl({
    int? id,
    required _i1.UuidValue userId,
    required DateTime importedAt,
    required String fileName,
    required DateTime statementStart,
    required DateTime statementEnd,
    required int totalTransactions,
    required int newTransactions,
    required int skippedDuplicates,
    required int skippedCredits,
  }) : super._(
         id: id,
         userId: userId,
         importedAt: importedAt,
         fileName: fileName,
         statementStart: statementStart,
         statementEnd: statementEnd,
         totalTransactions: totalTransactions,
         newTransactions: newTransactions,
         skippedDuplicates: skippedDuplicates,
         skippedCredits: skippedCredits,
       );

  /// Returns a shallow copy of this [ImportHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ImportHistory copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    DateTime? importedAt,
    String? fileName,
    DateTime? statementStart,
    DateTime? statementEnd,
    int? totalTransactions,
    int? newTransactions,
    int? skippedDuplicates,
    int? skippedCredits,
  }) {
    return ImportHistory(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      importedAt: importedAt ?? this.importedAt,
      fileName: fileName ?? this.fileName,
      statementStart: statementStart ?? this.statementStart,
      statementEnd: statementEnd ?? this.statementEnd,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      newTransactions: newTransactions ?? this.newTransactions,
      skippedDuplicates: skippedDuplicates ?? this.skippedDuplicates,
      skippedCredits: skippedCredits ?? this.skippedCredits,
    );
  }
}

class ImportHistoryUpdateTable extends _i1.UpdateTable<ImportHistoryTable> {
  ImportHistoryUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> importedAt(DateTime value) =>
      _i1.ColumnValue(
        table.importedAt,
        value,
      );

  _i1.ColumnValue<String, String> fileName(String value) => _i1.ColumnValue(
    table.fileName,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> statementStart(DateTime value) =>
      _i1.ColumnValue(
        table.statementStart,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> statementEnd(DateTime value) =>
      _i1.ColumnValue(
        table.statementEnd,
        value,
      );

  _i1.ColumnValue<int, int> totalTransactions(int value) => _i1.ColumnValue(
    table.totalTransactions,
    value,
  );

  _i1.ColumnValue<int, int> newTransactions(int value) => _i1.ColumnValue(
    table.newTransactions,
    value,
  );

  _i1.ColumnValue<int, int> skippedDuplicates(int value) => _i1.ColumnValue(
    table.skippedDuplicates,
    value,
  );

  _i1.ColumnValue<int, int> skippedCredits(int value) => _i1.ColumnValue(
    table.skippedCredits,
    value,
  );
}

class ImportHistoryTable extends _i1.Table<int?> {
  ImportHistoryTable({super.tableRelation})
    : super(tableName: 'import_history') {
    updateTable = ImportHistoryUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    importedAt = _i1.ColumnDateTime(
      'importedAt',
      this,
    );
    fileName = _i1.ColumnString(
      'fileName',
      this,
    );
    statementStart = _i1.ColumnDateTime(
      'statementStart',
      this,
    );
    statementEnd = _i1.ColumnDateTime(
      'statementEnd',
      this,
    );
    totalTransactions = _i1.ColumnInt(
      'totalTransactions',
      this,
    );
    newTransactions = _i1.ColumnInt(
      'newTransactions',
      this,
    );
    skippedDuplicates = _i1.ColumnInt(
      'skippedDuplicates',
      this,
    );
    skippedCredits = _i1.ColumnInt(
      'skippedCredits',
      this,
    );
  }

  late final ImportHistoryUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnDateTime importedAt;

  late final _i1.ColumnString fileName;

  late final _i1.ColumnDateTime statementStart;

  late final _i1.ColumnDateTime statementEnd;

  late final _i1.ColumnInt totalTransactions;

  late final _i1.ColumnInt newTransactions;

  late final _i1.ColumnInt skippedDuplicates;

  late final _i1.ColumnInt skippedCredits;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    importedAt,
    fileName,
    statementStart,
    statementEnd,
    totalTransactions,
    newTransactions,
    skippedDuplicates,
    skippedCredits,
  ];
}

class ImportHistoryInclude extends _i1.IncludeObject {
  ImportHistoryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ImportHistory.t;
}

class ImportHistoryIncludeList extends _i1.IncludeList {
  ImportHistoryIncludeList._({
    _i1.WhereExpressionBuilder<ImportHistoryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ImportHistory.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ImportHistory.t;
}

class ImportHistoryRepository {
  const ImportHistoryRepository._();

  /// Returns a list of [ImportHistory]s matching the given query parameters.
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
  Future<List<ImportHistory>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ImportHistoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ImportHistoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ImportHistoryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ImportHistory>(
      where: where?.call(ImportHistory.t),
      orderBy: orderBy?.call(ImportHistory.t),
      orderByList: orderByList?.call(ImportHistory.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ImportHistory] matching the given query parameters.
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
  Future<ImportHistory?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ImportHistoryTable>? where,
    int? offset,
    _i1.OrderByBuilder<ImportHistoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ImportHistoryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ImportHistory>(
      where: where?.call(ImportHistory.t),
      orderBy: orderBy?.call(ImportHistory.t),
      orderByList: orderByList?.call(ImportHistory.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ImportHistory] by its [id] or null if no such row exists.
  Future<ImportHistory?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ImportHistory>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ImportHistory]s in the list and returns the inserted rows.
  ///
  /// The returned [ImportHistory]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ImportHistory>> insert(
    _i1.DatabaseSession session,
    List<ImportHistory> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ImportHistory>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ImportHistory] and returns the inserted row.
  ///
  /// The returned [ImportHistory] will have its `id` field set.
  Future<ImportHistory> insertRow(
    _i1.DatabaseSession session,
    ImportHistory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ImportHistory>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ImportHistory]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ImportHistory>> update(
    _i1.DatabaseSession session,
    List<ImportHistory> rows, {
    _i1.ColumnSelections<ImportHistoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ImportHistory>(
      rows,
      columns: columns?.call(ImportHistory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ImportHistory]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ImportHistory> updateRow(
    _i1.DatabaseSession session,
    ImportHistory row, {
    _i1.ColumnSelections<ImportHistoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ImportHistory>(
      row,
      columns: columns?.call(ImportHistory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ImportHistory] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ImportHistory?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ImportHistoryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ImportHistory>(
      id,
      columnValues: columnValues(ImportHistory.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ImportHistory]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ImportHistory>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ImportHistoryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ImportHistoryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ImportHistoryTable>? orderBy,
    _i1.OrderByListBuilder<ImportHistoryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ImportHistory>(
      columnValues: columnValues(ImportHistory.t.updateTable),
      where: where(ImportHistory.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ImportHistory.t),
      orderByList: orderByList?.call(ImportHistory.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ImportHistory]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ImportHistory>> delete(
    _i1.DatabaseSession session,
    List<ImportHistory> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ImportHistory>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ImportHistory].
  Future<ImportHistory> deleteRow(
    _i1.DatabaseSession session,
    ImportHistory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ImportHistory>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ImportHistory>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ImportHistoryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ImportHistory>(
      where: where(ImportHistory.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ImportHistoryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ImportHistory>(
      where: where?.call(ImportHistory.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ImportHistory] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ImportHistoryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ImportHistory>(
      where: where(ImportHistory.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
