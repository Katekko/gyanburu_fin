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

abstract class PendingAction implements _i1.SerializableModel {
  PendingAction._({
    required this.type,
    this.merchantName,
    this.categoryName,
    this.propagate,
    this.categoryIcon,
    this.categoryColor,
  });

  factory PendingAction({
    required String type,
    String? merchantName,
    String? categoryName,
    bool? propagate,
    String? categoryIcon,
    String? categoryColor,
  }) = _PendingActionImpl;

  factory PendingAction.fromJson(Map<String, dynamic> jsonSerialization) {
    return PendingAction(
      type: jsonSerialization['type'] as String,
      merchantName: jsonSerialization['merchantName'] as String?,
      categoryName: jsonSerialization['categoryName'] as String?,
      propagate: jsonSerialization['propagate'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['propagate']),
      categoryIcon: jsonSerialization['categoryIcon'] as String?,
      categoryColor: jsonSerialization['categoryColor'] as String?,
    );
  }

  String type;

  String? merchantName;

  String? categoryName;

  bool? propagate;

  String? categoryIcon;

  String? categoryColor;

  /// Returns a shallow copy of this [PendingAction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PendingAction copyWith({
    String? type,
    String? merchantName,
    String? categoryName,
    bool? propagate,
    String? categoryIcon,
    String? categoryColor,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PendingAction',
      'type': type,
      if (merchantName != null) 'merchantName': merchantName,
      if (categoryName != null) 'categoryName': categoryName,
      if (propagate != null) 'propagate': propagate,
      if (categoryIcon != null) 'categoryIcon': categoryIcon,
      if (categoryColor != null) 'categoryColor': categoryColor,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PendingActionImpl extends PendingAction {
  _PendingActionImpl({
    required String type,
    String? merchantName,
    String? categoryName,
    bool? propagate,
    String? categoryIcon,
    String? categoryColor,
  }) : super._(
         type: type,
         merchantName: merchantName,
         categoryName: categoryName,
         propagate: propagate,
         categoryIcon: categoryIcon,
         categoryColor: categoryColor,
       );

  /// Returns a shallow copy of this [PendingAction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PendingAction copyWith({
    String? type,
    Object? merchantName = _Undefined,
    Object? categoryName = _Undefined,
    Object? propagate = _Undefined,
    Object? categoryIcon = _Undefined,
    Object? categoryColor = _Undefined,
  }) {
    return PendingAction(
      type: type ?? this.type,
      merchantName: merchantName is String? ? merchantName : this.merchantName,
      categoryName: categoryName is String? ? categoryName : this.categoryName,
      propagate: propagate is bool? ? propagate : this.propagate,
      categoryIcon: categoryIcon is String? ? categoryIcon : this.categoryIcon,
      categoryColor: categoryColor is String?
          ? categoryColor
          : this.categoryColor,
    );
  }
}
