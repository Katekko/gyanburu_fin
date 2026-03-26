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
import 'account_type.dart' as _i2;
import 'sync_status.dart' as _i3;

abstract class NubankAccount implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue userId;

  _i2.AccountType accountType;

  DateTime? lastSyncAt;

  _i3.SyncStatus syncStatus;

  DateTime? consentExpiresAt;

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
