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

abstract class FinancialTransaction implements _i1.SerializableModel {
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
    this.displayName,
    this.billingMonth,
    this.source,
    this.kind,
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
    String? displayName,
    String? billingMonth,
    String? source,
    String? kind,
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
      displayName: jsonSerialization['displayName'] as String?,
      billingMonth: jsonSerialization['billingMonth'] as String?,
      source: jsonSerialization['source'] as String?,
      kind: jsonSerialization['kind'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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

  String? displayName;

  String? billingMonth;

  String? source;

  String? kind;

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
    String? displayName,
    String? billingMonth,
    String? source,
    String? kind,
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
      if (displayName != null) 'displayName': displayName,
      if (billingMonth != null) 'billingMonth': billingMonth,
      if (source != null) 'source': source,
      if (kind != null) 'kind': kind,
    };
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
    String? displayName,
    String? billingMonth,
    String? source,
    String? kind,
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
         displayName: displayName,
         billingMonth: billingMonth,
         source: source,
         kind: kind,
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
    Object? displayName = _Undefined,
    Object? billingMonth = _Undefined,
    Object? source = _Undefined,
    Object? kind = _Undefined,
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
      displayName: displayName is String? ? displayName : this.displayName,
      billingMonth: billingMonth is String? ? billingMonth : this.billingMonth,
      source: source is String? ? source : this.source,
      kind: kind is String? ? kind : this.kind,
    );
  }
}
