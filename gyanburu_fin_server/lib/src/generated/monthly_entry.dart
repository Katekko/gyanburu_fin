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
import 'entry_type.dart' as _i2;

abstract class MonthlyEntry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MonthlyEntry._({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.name,
    required this.type,
    required this.amount,
    required this.month,
    required this.recurrent,
    required this.variable,
    required this.confirmed,
    this.dueDate,
    required this.paid,
    this.paidAt,
    this.paidAmount,
    this.paymentMethod,
    this.paymentNote,
  });

  factory MonthlyEntry({
    int? id,
    required _i1.UuidValue userId,
    required int categoryId,
    required String name,
    required _i2.EntryType type,
    required double amount,
    required String month,
    required bool recurrent,
    required bool variable,
    required bool confirmed,
    DateTime? dueDate,
    required bool paid,
    DateTime? paidAt,
    double? paidAmount,
    String? paymentMethod,
    String? paymentNote,
  }) = _MonthlyEntryImpl;

  factory MonthlyEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return MonthlyEntry(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      categoryId: jsonSerialization['categoryId'] as int,
      name: jsonSerialization['name'] as String,
      type: _i2.EntryType.fromJson((jsonSerialization['type'] as String)),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      month: jsonSerialization['month'] as String,
      recurrent: _i1.BoolJsonExtension.fromJson(jsonSerialization['recurrent']),
      variable: _i1.BoolJsonExtension.fromJson(jsonSerialization['variable']),
      confirmed: _i1.BoolJsonExtension.fromJson(jsonSerialization['confirmed']),
      dueDate: jsonSerialization['dueDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      paid: _i1.BoolJsonExtension.fromJson(jsonSerialization['paid']),
      paidAt: jsonSerialization['paidAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['paidAt']),
      paidAmount: (jsonSerialization['paidAmount'] as num?)?.toDouble(),
      paymentMethod: jsonSerialization['paymentMethod'] as String?,
      paymentNote: jsonSerialization['paymentNote'] as String?,
    );
  }

  static final t = MonthlyEntryTable();

  static const db = MonthlyEntryRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  int categoryId;

  String name;

  _i2.EntryType type;

  double amount;

  String month;

  bool recurrent;

  bool variable;

  bool confirmed;

  DateTime? dueDate;

  bool paid;

  DateTime? paidAt;

  double? paidAmount;

  String? paymentMethod;

  String? paymentNote;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MonthlyEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MonthlyEntry copyWith({
    int? id,
    _i1.UuidValue? userId,
    int? categoryId,
    String? name,
    _i2.EntryType? type,
    double? amount,
    String? month,
    bool? recurrent,
    bool? variable,
    bool? confirmed,
    DateTime? dueDate,
    bool? paid,
    DateTime? paidAt,
    double? paidAmount,
    String? paymentMethod,
    String? paymentNote,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MonthlyEntry',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'categoryId': categoryId,
      'name': name,
      'type': type.toJson(),
      'amount': amount,
      'month': month,
      'recurrent': recurrent,
      'variable': variable,
      'confirmed': confirmed,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      'paid': paid,
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
      if (paidAmount != null) 'paidAmount': paidAmount,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (paymentNote != null) 'paymentNote': paymentNote,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MonthlyEntry',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'categoryId': categoryId,
      'name': name,
      'type': type.toJson(),
      'amount': amount,
      'month': month,
      'recurrent': recurrent,
      'variable': variable,
      'confirmed': confirmed,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      'paid': paid,
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
      if (paidAmount != null) 'paidAmount': paidAmount,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (paymentNote != null) 'paymentNote': paymentNote,
    };
  }

  static MonthlyEntryInclude include() {
    return MonthlyEntryInclude._();
  }

  static MonthlyEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<MonthlyEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MonthlyEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MonthlyEntryTable>? orderByList,
    MonthlyEntryInclude? include,
  }) {
    return MonthlyEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MonthlyEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MonthlyEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MonthlyEntryImpl extends MonthlyEntry {
  _MonthlyEntryImpl({
    int? id,
    required _i1.UuidValue userId,
    required int categoryId,
    required String name,
    required _i2.EntryType type,
    required double amount,
    required String month,
    required bool recurrent,
    required bool variable,
    required bool confirmed,
    DateTime? dueDate,
    required bool paid,
    DateTime? paidAt,
    double? paidAmount,
    String? paymentMethod,
    String? paymentNote,
  }) : super._(
         id: id,
         userId: userId,
         categoryId: categoryId,
         name: name,
         type: type,
         amount: amount,
         month: month,
         recurrent: recurrent,
         variable: variable,
         confirmed: confirmed,
         dueDate: dueDate,
         paid: paid,
         paidAt: paidAt,
         paidAmount: paidAmount,
         paymentMethod: paymentMethod,
         paymentNote: paymentNote,
       );

  /// Returns a shallow copy of this [MonthlyEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MonthlyEntry copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    int? categoryId,
    String? name,
    _i2.EntryType? type,
    double? amount,
    String? month,
    bool? recurrent,
    bool? variable,
    bool? confirmed,
    Object? dueDate = _Undefined,
    bool? paid,
    Object? paidAt = _Undefined,
    Object? paidAmount = _Undefined,
    Object? paymentMethod = _Undefined,
    Object? paymentNote = _Undefined,
  }) {
    return MonthlyEntry(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      month: month ?? this.month,
      recurrent: recurrent ?? this.recurrent,
      variable: variable ?? this.variable,
      confirmed: confirmed ?? this.confirmed,
      dueDate: dueDate is DateTime? ? dueDate : this.dueDate,
      paid: paid ?? this.paid,
      paidAt: paidAt is DateTime? ? paidAt : this.paidAt,
      paidAmount: paidAmount is double? ? paidAmount : this.paidAmount,
      paymentMethod: paymentMethod is String?
          ? paymentMethod
          : this.paymentMethod,
      paymentNote: paymentNote is String? ? paymentNote : this.paymentNote,
    );
  }
}

class MonthlyEntryUpdateTable extends _i1.UpdateTable<MonthlyEntryTable> {
  MonthlyEntryUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<int, int> categoryId(int value) => _i1.ColumnValue(
    table.categoryId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<_i2.EntryType, _i2.EntryType> type(_i2.EntryType value) =>
      _i1.ColumnValue(
        table.type,
        value,
      );

  _i1.ColumnValue<double, double> amount(double value) => _i1.ColumnValue(
    table.amount,
    value,
  );

  _i1.ColumnValue<String, String> month(String value) => _i1.ColumnValue(
    table.month,
    value,
  );

  _i1.ColumnValue<bool, bool> recurrent(bool value) => _i1.ColumnValue(
    table.recurrent,
    value,
  );

  _i1.ColumnValue<bool, bool> variable(bool value) => _i1.ColumnValue(
    table.variable,
    value,
  );

  _i1.ColumnValue<bool, bool> confirmed(bool value) => _i1.ColumnValue(
    table.confirmed,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dueDate(DateTime? value) =>
      _i1.ColumnValue(
        table.dueDate,
        value,
      );

  _i1.ColumnValue<bool, bool> paid(bool value) => _i1.ColumnValue(
    table.paid,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> paidAt(DateTime? value) =>
      _i1.ColumnValue(
        table.paidAt,
        value,
      );

  _i1.ColumnValue<double, double> paidAmount(double? value) => _i1.ColumnValue(
    table.paidAmount,
    value,
  );

  _i1.ColumnValue<String, String> paymentMethod(String? value) =>
      _i1.ColumnValue(
        table.paymentMethod,
        value,
      );

  _i1.ColumnValue<String, String> paymentNote(String? value) => _i1.ColumnValue(
    table.paymentNote,
    value,
  );
}

class MonthlyEntryTable extends _i1.Table<int?> {
  MonthlyEntryTable({super.tableRelation}) : super(tableName: 'monthly_entry') {
    updateTable = MonthlyEntryUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    categoryId = _i1.ColumnInt(
      'categoryId',
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
    month = _i1.ColumnString(
      'month',
      this,
    );
    recurrent = _i1.ColumnBool(
      'recurrent',
      this,
    );
    variable = _i1.ColumnBool(
      'variable',
      this,
    );
    confirmed = _i1.ColumnBool(
      'confirmed',
      this,
    );
    dueDate = _i1.ColumnDateTime(
      'dueDate',
      this,
    );
    paid = _i1.ColumnBool(
      'paid',
      this,
    );
    paidAt = _i1.ColumnDateTime(
      'paidAt',
      this,
    );
    paidAmount = _i1.ColumnDouble(
      'paidAmount',
      this,
    );
    paymentMethod = _i1.ColumnString(
      'paymentMethod',
      this,
    );
    paymentNote = _i1.ColumnString(
      'paymentNote',
      this,
    );
  }

  late final MonthlyEntryUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnInt categoryId;

  late final _i1.ColumnString name;

  late final _i1.ColumnEnum<_i2.EntryType> type;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnString month;

  late final _i1.ColumnBool recurrent;

  late final _i1.ColumnBool variable;

  late final _i1.ColumnBool confirmed;

  late final _i1.ColumnDateTime dueDate;

  late final _i1.ColumnBool paid;

  late final _i1.ColumnDateTime paidAt;

  late final _i1.ColumnDouble paidAmount;

  late final _i1.ColumnString paymentMethod;

  late final _i1.ColumnString paymentNote;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    categoryId,
    name,
    type,
    amount,
    month,
    recurrent,
    variable,
    confirmed,
    dueDate,
    paid,
    paidAt,
    paidAmount,
    paymentMethod,
    paymentNote,
  ];
}

class MonthlyEntryInclude extends _i1.IncludeObject {
  MonthlyEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => MonthlyEntry.t;
}

class MonthlyEntryIncludeList extends _i1.IncludeList {
  MonthlyEntryIncludeList._({
    _i1.WhereExpressionBuilder<MonthlyEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MonthlyEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MonthlyEntry.t;
}

class MonthlyEntryRepository {
  const MonthlyEntryRepository._();

  /// Returns a list of [MonthlyEntry]s matching the given query parameters.
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
  Future<List<MonthlyEntry>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<MonthlyEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MonthlyEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MonthlyEntryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MonthlyEntry>(
      where: where?.call(MonthlyEntry.t),
      orderBy: orderBy?.call(MonthlyEntry.t),
      orderByList: orderByList?.call(MonthlyEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MonthlyEntry] matching the given query parameters.
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
  Future<MonthlyEntry?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<MonthlyEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<MonthlyEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MonthlyEntryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MonthlyEntry>(
      where: where?.call(MonthlyEntry.t),
      orderBy: orderBy?.call(MonthlyEntry.t),
      orderByList: orderByList?.call(MonthlyEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MonthlyEntry] by its [id] or null if no such row exists.
  Future<MonthlyEntry?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MonthlyEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MonthlyEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [MonthlyEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<MonthlyEntry>> insert(
    _i1.DatabaseSession session,
    List<MonthlyEntry> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<MonthlyEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [MonthlyEntry] and returns the inserted row.
  ///
  /// The returned [MonthlyEntry] will have its `id` field set.
  Future<MonthlyEntry> insertRow(
    _i1.DatabaseSession session,
    MonthlyEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MonthlyEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MonthlyEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MonthlyEntry>> update(
    _i1.DatabaseSession session,
    List<MonthlyEntry> rows, {
    _i1.ColumnSelections<MonthlyEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MonthlyEntry>(
      rows,
      columns: columns?.call(MonthlyEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MonthlyEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MonthlyEntry> updateRow(
    _i1.DatabaseSession session,
    MonthlyEntry row, {
    _i1.ColumnSelections<MonthlyEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MonthlyEntry>(
      row,
      columns: columns?.call(MonthlyEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MonthlyEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MonthlyEntry?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<MonthlyEntryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<MonthlyEntry>(
      id,
      columnValues: columnValues(MonthlyEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MonthlyEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<MonthlyEntry>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<MonthlyEntryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<MonthlyEntryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MonthlyEntryTable>? orderBy,
    _i1.OrderByListBuilder<MonthlyEntryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<MonthlyEntry>(
      columnValues: columnValues(MonthlyEntry.t.updateTable),
      where: where(MonthlyEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MonthlyEntry.t),
      orderByList: orderByList?.call(MonthlyEntry.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [MonthlyEntry]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MonthlyEntry>> delete(
    _i1.DatabaseSession session,
    List<MonthlyEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MonthlyEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MonthlyEntry].
  Future<MonthlyEntry> deleteRow(
    _i1.DatabaseSession session,
    MonthlyEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MonthlyEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MonthlyEntry>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<MonthlyEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MonthlyEntry>(
      where: where(MonthlyEntry.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<MonthlyEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MonthlyEntry>(
      where: where?.call(MonthlyEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MonthlyEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<MonthlyEntryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MonthlyEntry>(
      where: where(MonthlyEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
