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
import 'bill_status.dart' as _i2;

abstract class Bill implements _i1.SerializableModel {
  Bill._({
    this.id,
    required this.userId,
    required this.merchantName,
    required this.amount,
    required this.dueAt,
    required this.status,
    required this.recurrent,
  });

  factory Bill({
    int? id,
    required _i1.UuidValue userId,
    required String merchantName,
    required double amount,
    required DateTime dueAt,
    required _i2.BillStatus status,
    required bool recurrent,
  }) = _BillImpl;

  factory Bill.fromJson(Map<String, dynamic> jsonSerialization) {
    return Bill(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      merchantName: jsonSerialization['merchantName'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      dueAt: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      status: _i2.BillStatus.fromJson((jsonSerialization['status'] as String)),
      recurrent: _i1.BoolJsonExtension.fromJson(jsonSerialization['recurrent']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue userId;

  String merchantName;

  double amount;

  DateTime dueAt;

  _i2.BillStatus status;

  bool recurrent;

  /// Returns a shallow copy of this [Bill]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Bill copyWith({
    int? id,
    _i1.UuidValue? userId,
    String? merchantName,
    double? amount,
    DateTime? dueAt,
    _i2.BillStatus? status,
    bool? recurrent,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Bill',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'merchantName': merchantName,
      'amount': amount,
      'dueAt': dueAt.toJson(),
      'status': status.toJson(),
      'recurrent': recurrent,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BillImpl extends Bill {
  _BillImpl({
    int? id,
    required _i1.UuidValue userId,
    required String merchantName,
    required double amount,
    required DateTime dueAt,
    required _i2.BillStatus status,
    required bool recurrent,
  }) : super._(
         id: id,
         userId: userId,
         merchantName: merchantName,
         amount: amount,
         dueAt: dueAt,
         status: status,
         recurrent: recurrent,
       );

  /// Returns a shallow copy of this [Bill]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Bill copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? merchantName,
    double? amount,
    DateTime? dueAt,
    _i2.BillStatus? status,
    bool? recurrent,
  }) {
    return Bill(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      merchantName: merchantName ?? this.merchantName,
      amount: amount ?? this.amount,
      dueAt: dueAt ?? this.dueAt,
      status: status ?? this.status,
      recurrent: recurrent ?? this.recurrent,
    );
  }
}
