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
import 'attachment_kind.dart' as _i2;

abstract class Attachment
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Attachment._({
    this.id,
    required this.userId,
    required this.entryId,
    required this.kind,
    required this.storagePath,
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
    required this.uploadedAt,
  });

  factory Attachment({
    int? id,
    required _i1.UuidValue userId,
    required int entryId,
    required _i2.AttachmentKind kind,
    required String storagePath,
    required String fileName,
    required String contentType,
    required int sizeBytes,
    required DateTime uploadedAt,
  }) = _AttachmentImpl;

  factory Attachment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Attachment(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      entryId: jsonSerialization['entryId'] as int,
      kind: _i2.AttachmentKind.fromJson((jsonSerialization['kind'] as String)),
      storagePath: jsonSerialization['storagePath'] as String,
      fileName: jsonSerialization['fileName'] as String,
      contentType: jsonSerialization['contentType'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      uploadedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['uploadedAt'],
      ),
    );
  }

  static final t = AttachmentTable();

  static const db = AttachmentRepository._();

  @override
  int? id;

  _i1.UuidValue userId;

  int entryId;

  _i2.AttachmentKind kind;

  String storagePath;

  String fileName;

  String contentType;

  int sizeBytes;

  DateTime uploadedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Attachment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Attachment copyWith({
    int? id,
    _i1.UuidValue? userId,
    int? entryId,
    _i2.AttachmentKind? kind,
    String? storagePath,
    String? fileName,
    String? contentType,
    int? sizeBytes,
    DateTime? uploadedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Attachment',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'entryId': entryId,
      'kind': kind.toJson(),
      'storagePath': storagePath,
      'fileName': fileName,
      'contentType': contentType,
      'sizeBytes': sizeBytes,
      'uploadedAt': uploadedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Attachment',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'entryId': entryId,
      'kind': kind.toJson(),
      'storagePath': storagePath,
      'fileName': fileName,
      'contentType': contentType,
      'sizeBytes': sizeBytes,
      'uploadedAt': uploadedAt.toJson(),
    };
  }

  static AttachmentInclude include() {
    return AttachmentInclude._();
  }

  static AttachmentIncludeList includeList({
    _i1.WhereExpressionBuilder<AttachmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AttachmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AttachmentTable>? orderByList,
    AttachmentInclude? include,
  }) {
    return AttachmentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Attachment.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Attachment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttachmentImpl extends Attachment {
  _AttachmentImpl({
    int? id,
    required _i1.UuidValue userId,
    required int entryId,
    required _i2.AttachmentKind kind,
    required String storagePath,
    required String fileName,
    required String contentType,
    required int sizeBytes,
    required DateTime uploadedAt,
  }) : super._(
         id: id,
         userId: userId,
         entryId: entryId,
         kind: kind,
         storagePath: storagePath,
         fileName: fileName,
         contentType: contentType,
         sizeBytes: sizeBytes,
         uploadedAt: uploadedAt,
       );

  /// Returns a shallow copy of this [Attachment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Attachment copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    int? entryId,
    _i2.AttachmentKind? kind,
    String? storagePath,
    String? fileName,
    String? contentType,
    int? sizeBytes,
    DateTime? uploadedAt,
  }) {
    return Attachment(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      entryId: entryId ?? this.entryId,
      kind: kind ?? this.kind,
      storagePath: storagePath ?? this.storagePath,
      fileName: fileName ?? this.fileName,
      contentType: contentType ?? this.contentType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}

class AttachmentUpdateTable extends _i1.UpdateTable<AttachmentTable> {
  AttachmentUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<int, int> entryId(int value) => _i1.ColumnValue(
    table.entryId,
    value,
  );

  _i1.ColumnValue<_i2.AttachmentKind, _i2.AttachmentKind> kind(
    _i2.AttachmentKind value,
  ) => _i1.ColumnValue(
    table.kind,
    value,
  );

  _i1.ColumnValue<String, String> storagePath(String value) => _i1.ColumnValue(
    table.storagePath,
    value,
  );

  _i1.ColumnValue<String, String> fileName(String value) => _i1.ColumnValue(
    table.fileName,
    value,
  );

  _i1.ColumnValue<String, String> contentType(String value) => _i1.ColumnValue(
    table.contentType,
    value,
  );

  _i1.ColumnValue<int, int> sizeBytes(int value) => _i1.ColumnValue(
    table.sizeBytes,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> uploadedAt(DateTime value) =>
      _i1.ColumnValue(
        table.uploadedAt,
        value,
      );
}

class AttachmentTable extends _i1.Table<int?> {
  AttachmentTable({super.tableRelation}) : super(tableName: 'attachment') {
    updateTable = AttachmentUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    entryId = _i1.ColumnInt(
      'entryId',
      this,
    );
    kind = _i1.ColumnEnum(
      'kind',
      this,
      _i1.EnumSerialization.byName,
    );
    storagePath = _i1.ColumnString(
      'storagePath',
      this,
    );
    fileName = _i1.ColumnString(
      'fileName',
      this,
    );
    contentType = _i1.ColumnString(
      'contentType',
      this,
    );
    sizeBytes = _i1.ColumnInt(
      'sizeBytes',
      this,
    );
    uploadedAt = _i1.ColumnDateTime(
      'uploadedAt',
      this,
    );
  }

  late final AttachmentUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnInt entryId;

  late final _i1.ColumnEnum<_i2.AttachmentKind> kind;

  late final _i1.ColumnString storagePath;

  late final _i1.ColumnString fileName;

  late final _i1.ColumnString contentType;

  late final _i1.ColumnInt sizeBytes;

  late final _i1.ColumnDateTime uploadedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    entryId,
    kind,
    storagePath,
    fileName,
    contentType,
    sizeBytes,
    uploadedAt,
  ];
}

class AttachmentInclude extends _i1.IncludeObject {
  AttachmentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Attachment.t;
}

class AttachmentIncludeList extends _i1.IncludeList {
  AttachmentIncludeList._({
    _i1.WhereExpressionBuilder<AttachmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Attachment.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Attachment.t;
}

class AttachmentRepository {
  const AttachmentRepository._();

  /// Returns a list of [Attachment]s matching the given query parameters.
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
  Future<List<Attachment>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AttachmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AttachmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AttachmentTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Attachment>(
      where: where?.call(Attachment.t),
      orderBy: orderBy?.call(Attachment.t),
      orderByList: orderByList?.call(Attachment.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Attachment] matching the given query parameters.
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
  Future<Attachment?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AttachmentTable>? where,
    int? offset,
    _i1.OrderByBuilder<AttachmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AttachmentTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Attachment>(
      where: where?.call(Attachment.t),
      orderBy: orderBy?.call(Attachment.t),
      orderByList: orderByList?.call(Attachment.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Attachment] by its [id] or null if no such row exists.
  Future<Attachment?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Attachment>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Attachment]s in the list and returns the inserted rows.
  ///
  /// The returned [Attachment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Attachment>> insert(
    _i1.DatabaseSession session,
    List<Attachment> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Attachment>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Attachment] and returns the inserted row.
  ///
  /// The returned [Attachment] will have its `id` field set.
  Future<Attachment> insertRow(
    _i1.DatabaseSession session,
    Attachment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Attachment>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Attachment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Attachment>> update(
    _i1.DatabaseSession session,
    List<Attachment> rows, {
    _i1.ColumnSelections<AttachmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Attachment>(
      rows,
      columns: columns?.call(Attachment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Attachment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Attachment> updateRow(
    _i1.DatabaseSession session,
    Attachment row, {
    _i1.ColumnSelections<AttachmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Attachment>(
      row,
      columns: columns?.call(Attachment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Attachment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Attachment?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AttachmentUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Attachment>(
      id,
      columnValues: columnValues(Attachment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Attachment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Attachment>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AttachmentUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AttachmentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AttachmentTable>? orderBy,
    _i1.OrderByListBuilder<AttachmentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Attachment>(
      columnValues: columnValues(Attachment.t.updateTable),
      where: where(Attachment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Attachment.t),
      orderByList: orderByList?.call(Attachment.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Attachment]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Attachment>> delete(
    _i1.DatabaseSession session,
    List<Attachment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Attachment>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Attachment].
  Future<Attachment> deleteRow(
    _i1.DatabaseSession session,
    Attachment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Attachment>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Attachment>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AttachmentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Attachment>(
      where: where(Attachment.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AttachmentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Attachment>(
      where: where?.call(Attachment.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Attachment] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AttachmentTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Attachment>(
      where: where(Attachment.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
