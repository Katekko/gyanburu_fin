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
import 'income_type.dart' as _i2;

abstract class IncomeSource implements _i1.SerializableModel {
  IncomeSource._({
    this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.amount,
    required this.month,
  });

  factory IncomeSource({
    int? id,
    required _i1.UuidValue userId,
    required String name,
    required _i2.IncomeType type,
    required double amount,
    required DateTime month,
  }) = _IncomeSourceImpl;

  factory IncomeSource.fromJson(Map<String, dynamic> jsonSerialization) {
    return IncomeSource(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      name: jsonSerialization['name'] as String,
      type: _i2.IncomeType.fromJson((jsonSerialization['type'] as String)),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      month: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['month']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue userId;

  String name;

  _i2.IncomeType type;

  double amount;

  DateTime month;

  /// Returns a shallow copy of this [IncomeSource]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IncomeSource copyWith({
    int? id,
    _i1.UuidValue? userId,
    String? name,
    _i2.IncomeType? type,
    double? amount,
    DateTime? month,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IncomeSource',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'name': name,
      'type': type.toJson(),
      'amount': amount,
      'month': month.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IncomeSourceImpl extends IncomeSource {
  _IncomeSourceImpl({
    int? id,
    required _i1.UuidValue userId,
    required String name,
    required _i2.IncomeType type,
    required double amount,
    required DateTime month,
  }) : super._(
         id: id,
         userId: userId,
         name: name,
         type: type,
         amount: amount,
         month: month,
       );

  /// Returns a shallow copy of this [IncomeSource]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IncomeSource copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? name,
    _i2.IncomeType? type,
    double? amount,
    DateTime? month,
  }) {
    return IncomeSource(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      month: month ?? this.month,
    );
  }
}
