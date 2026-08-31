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

abstract class BenefitWallet
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  BenefitWallet._({
    this.id,
    required this.userId,
    required this.provider,
    required this.slug,
    required this.name,
    required this.anchorBalance,
    required this.anchorDate,
    this.monthlyTopupAmount,
  });

  factory BenefitWallet({
    int? id,
    required _i1.UuidValue userId,
    required String provider,
    required String slug,
    required String name,
    required double anchorBalance,
    required DateTime anchorDate,
    double? monthlyTopupAmount,
  }) = _BenefitWalletImpl;

  factory BenefitWallet.fromJson(Map<String, dynamic> jsonSerialization) {
    return BenefitWallet(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      provider: jsonSerialization['provider'] as String,
      slug: jsonSerialization['slug'] as String,
      name: jsonSerialization['name'] as String,
      anchorBalance: (jsonSerialization['anchorBalance'] as num).toDouble(),
      anchorDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['anchorDate'],
      ),
      monthlyTopupAmount: (jsonSerialization['monthlyTopupAmount'] as num?)
          ?.toDouble(),
    );
  }

  static final t = BenefitWalletTable();

  static const db = BenefitWalletRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  String provider;

  String slug;

  String name;

  double anchorBalance;

  DateTime anchorDate;

  double? monthlyTopupAmount;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BenefitWallet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BenefitWallet copyWith({
    int? id,
    _i1.UuidValue? userId,
    String? provider,
    String? slug,
    String? name,
    double? anchorBalance,
    DateTime? anchorDate,
    double? monthlyTopupAmount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BenefitWallet',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'provider': provider,
      'slug': slug,
      'name': name,
      'anchorBalance': anchorBalance,
      'anchorDate': anchorDate.toJson(),
      if (monthlyTopupAmount != null) 'monthlyTopupAmount': monthlyTopupAmount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BenefitWallet',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'provider': provider,
      'slug': slug,
      'name': name,
      'anchorBalance': anchorBalance,
      'anchorDate': anchorDate.toJson(),
      if (monthlyTopupAmount != null) 'monthlyTopupAmount': monthlyTopupAmount,
    };
  }

  static BenefitWalletInclude include() {
    return BenefitWalletInclude._();
  }

  static BenefitWalletIncludeList includeList({
    _i1.WhereExpressionBuilder<BenefitWalletTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BenefitWalletTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BenefitWalletTable>? orderByList,
    BenefitWalletInclude? include,
  }) {
    return BenefitWalletIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BenefitWallet.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BenefitWallet.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BenefitWalletImpl extends BenefitWallet {
  _BenefitWalletImpl({
    int? id,
    required _i1.UuidValue userId,
    required String provider,
    required String slug,
    required String name,
    required double anchorBalance,
    required DateTime anchorDate,
    double? monthlyTopupAmount,
  }) : super._(
         id: id,
         userId: userId,
         provider: provider,
         slug: slug,
         name: name,
         anchorBalance: anchorBalance,
         anchorDate: anchorDate,
         monthlyTopupAmount: monthlyTopupAmount,
       );

  /// Returns a shallow copy of this [BenefitWallet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BenefitWallet copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? provider,
    String? slug,
    String? name,
    double? anchorBalance,
    DateTime? anchorDate,
    Object? monthlyTopupAmount = _Undefined,
  }) {
    return BenefitWallet(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      provider: provider ?? this.provider,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      anchorBalance: anchorBalance ?? this.anchorBalance,
      anchorDate: anchorDate ?? this.anchorDate,
      monthlyTopupAmount: monthlyTopupAmount is double?
          ? monthlyTopupAmount
          : this.monthlyTopupAmount,
    );
  }
}

class BenefitWalletUpdateTable extends _i1.UpdateTable<BenefitWalletTable> {
  BenefitWalletUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> provider(String value) => _i1.ColumnValue(
    table.provider,
    value,
  );

  _i1.ColumnValue<String, String> slug(String value) => _i1.ColumnValue(
    table.slug,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<double, double> anchorBalance(double value) =>
      _i1.ColumnValue(
        table.anchorBalance,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> anchorDate(DateTime value) =>
      _i1.ColumnValue(
        table.anchorDate,
        value,
      );

  _i1.ColumnValue<double, double> monthlyTopupAmount(double? value) =>
      _i1.ColumnValue(
        table.monthlyTopupAmount,
        value,
      );
}

class BenefitWalletTable extends _i1.Table<int?> {
  BenefitWalletTable({super.tableRelation})
    : super(tableName: 'benefit_wallet') {
    updateTable = BenefitWalletUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    provider = _i1.ColumnString(
      'provider',
      this,
    );
    slug = _i1.ColumnString(
      'slug',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    anchorBalance = _i1.ColumnDouble(
      'anchorBalance',
      this,
    );
    anchorDate = _i1.ColumnDateTime(
      'anchorDate',
      this,
    );
    monthlyTopupAmount = _i1.ColumnDouble(
      'monthlyTopupAmount',
      this,
    );
  }

  late final BenefitWalletUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString provider;

  late final _i1.ColumnString slug;

  late final _i1.ColumnString name;

  late final _i1.ColumnDouble anchorBalance;

  late final _i1.ColumnDateTime anchorDate;

  late final _i1.ColumnDouble monthlyTopupAmount;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    provider,
    slug,
    name,
    anchorBalance,
    anchorDate,
    monthlyTopupAmount,
  ];
}

class BenefitWalletInclude extends _i1.IncludeObject {
  BenefitWalletInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BenefitWallet.t;
}

class BenefitWalletIncludeList extends _i1.IncludeList {
  BenefitWalletIncludeList._({
    _i1.WhereExpressionBuilder<BenefitWalletTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BenefitWallet.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BenefitWallet.t;
}

class BenefitWalletRepository {
  const BenefitWalletRepository._();

  /// Returns a list of [BenefitWallet]s matching the given query parameters.
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
  Future<List<BenefitWallet>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BenefitWalletTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BenefitWalletTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BenefitWalletTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BenefitWallet>(
      where: where?.call(BenefitWallet.t),
      orderBy: orderBy?.call(BenefitWallet.t),
      orderByList: orderByList?.call(BenefitWallet.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BenefitWallet] matching the given query parameters.
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
  Future<BenefitWallet?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BenefitWalletTable>? where,
    int? offset,
    _i1.OrderByBuilder<BenefitWalletTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BenefitWalletTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BenefitWallet>(
      where: where?.call(BenefitWallet.t),
      orderBy: orderBy?.call(BenefitWallet.t),
      orderByList: orderByList?.call(BenefitWallet.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BenefitWallet] by its [id] or null if no such row exists.
  Future<BenefitWallet?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BenefitWallet>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BenefitWallet]s in the list and returns the inserted rows.
  ///
  /// The returned [BenefitWallet]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<BenefitWallet>> insert(
    _i1.DatabaseSession session,
    List<BenefitWallet> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<BenefitWallet>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [BenefitWallet] and returns the inserted row.
  ///
  /// The returned [BenefitWallet] will have its `id` field set.
  Future<BenefitWallet> insertRow(
    _i1.DatabaseSession session,
    BenefitWallet row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BenefitWallet>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BenefitWallet]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BenefitWallet>> update(
    _i1.DatabaseSession session,
    List<BenefitWallet> rows, {
    _i1.ColumnSelections<BenefitWalletTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BenefitWallet>(
      rows,
      columns: columns?.call(BenefitWallet.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BenefitWallet]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BenefitWallet> updateRow(
    _i1.DatabaseSession session,
    BenefitWallet row, {
    _i1.ColumnSelections<BenefitWalletTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BenefitWallet>(
      row,
      columns: columns?.call(BenefitWallet.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BenefitWallet] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BenefitWallet?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<BenefitWalletUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<BenefitWallet>(
      id,
      columnValues: columnValues(BenefitWallet.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BenefitWallet]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<BenefitWallet>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<BenefitWalletUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<BenefitWalletTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BenefitWalletTable>? orderBy,
    _i1.OrderByListBuilder<BenefitWalletTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<BenefitWallet>(
      columnValues: columnValues(BenefitWallet.t.updateTable),
      where: where(BenefitWallet.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BenefitWallet.t),
      orderByList: orderByList?.call(BenefitWallet.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [BenefitWallet]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BenefitWallet>> delete(
    _i1.DatabaseSession session,
    List<BenefitWallet> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BenefitWallet>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BenefitWallet].
  Future<BenefitWallet> deleteRow(
    _i1.DatabaseSession session,
    BenefitWallet row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BenefitWallet>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BenefitWallet>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BenefitWalletTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BenefitWallet>(
      where: where(BenefitWallet.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BenefitWalletTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BenefitWallet>(
      where: where?.call(BenefitWallet.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BenefitWallet] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BenefitWalletTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BenefitWallet>(
      where: where(BenefitWallet.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
