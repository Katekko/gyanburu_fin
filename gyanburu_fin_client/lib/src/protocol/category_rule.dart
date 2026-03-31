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

abstract class CategoryRule implements _i1.SerializableModel {
  CategoryRule._({
    this.id,
    required this.userId,
    required this.merchantPattern,
    required this.categoryId,
  });

  factory CategoryRule({
    int? id,
    required _i1.UuidValue userId,
    required String merchantPattern,
    required int categoryId,
  }) = _CategoryRuleImpl;

  factory CategoryRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return CategoryRule(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      merchantPattern: jsonSerialization['merchantPattern'] as String,
      categoryId: jsonSerialization['categoryId'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue userId;

  String merchantPattern;

  int categoryId;

  /// Returns a shallow copy of this [CategoryRule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CategoryRule copyWith({
    int? id,
    _i1.UuidValue? userId,
    String? merchantPattern,
    int? categoryId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CategoryRule',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'merchantPattern': merchantPattern,
      'categoryId': categoryId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CategoryRuleImpl extends CategoryRule {
  _CategoryRuleImpl({
    int? id,
    required _i1.UuidValue userId,
    required String merchantPattern,
    required int categoryId,
  }) : super._(
         id: id,
         userId: userId,
         merchantPattern: merchantPattern,
         categoryId: categoryId,
       );

  /// Returns a shallow copy of this [CategoryRule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CategoryRule copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? merchantPattern,
    int? categoryId,
  }) {
    return CategoryRule(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      merchantPattern: merchantPattern ?? this.merchantPattern,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
