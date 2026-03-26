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
import 'sync_status.dart' as _i2;

abstract class SyncLog implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue nubankAccountId;

  DateTime syncedAt;

  _i2.SyncStatus status;

  String? errorMessage;

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
