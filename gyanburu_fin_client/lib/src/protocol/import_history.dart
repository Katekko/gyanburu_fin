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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ImportHistory implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
