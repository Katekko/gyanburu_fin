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

abstract class BudgetCategory implements _i1.SerializableModel {
  BudgetCategory._({
    this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.limitAmount,
    required this.month,
  });

  factory BudgetCategory({
    int? id,
    required _i1.UuidValue userId,
    required String name,
    required String icon,
    required double limitAmount,
    required DateTime month,
  }) = _BudgetCategoryImpl;

  factory BudgetCategory.fromJson(Map<String, dynamic> jsonSerialization) {
    return BudgetCategory(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      name: jsonSerialization['name'] as String,
      icon: jsonSerialization['icon'] as String,
      limitAmount: (jsonSerialization['limitAmount'] as num).toDouble(),
      month: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['month']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue userId;

  String name;

  String icon;

  double limitAmount;

  DateTime month;

  /// Returns a shallow copy of this [BudgetCategory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BudgetCategory copyWith({
    int? id,
    _i1.UuidValue? userId,
    String? name,
    String? icon,
    double? limitAmount,
    DateTime? month,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BudgetCategory',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'name': name,
      'icon': icon,
      'limitAmount': limitAmount,
      'month': month.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BudgetCategoryImpl extends BudgetCategory {
  _BudgetCategoryImpl({
    int? id,
    required _i1.UuidValue userId,
    required String name,
    required String icon,
    required double limitAmount,
    required DateTime month,
  }) : super._(
         id: id,
         userId: userId,
         name: name,
         icon: icon,
         limitAmount: limitAmount,
         month: month,
       );

  /// Returns a shallow copy of this [BudgetCategory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BudgetCategory copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? name,
    String? icon,
    double? limitAmount,
    DateTime? month,
  }) {
    return BudgetCategory(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      limitAmount: limitAmount ?? this.limitAmount,
      month: month ?? this.month,
    );
  }
}
