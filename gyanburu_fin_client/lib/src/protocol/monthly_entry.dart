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
import 'entry_type.dart' as _i2;

abstract class MonthlyEntry implements _i1.SerializableModel {
  MonthlyEntry._({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.name,
    required this.type,
    required this.amount,
    required this.month,
    required this.recurrent,
    required this.variable,
    required this.confirmed,
    this.dueDate,
    required this.paid,
    this.paidAt,
    this.paidAmount,
    this.paymentMethod,
    this.paymentNote,
  });

  factory MonthlyEntry({
    int? id,
    required _i1.UuidValue userId,
    required int categoryId,
    required String name,
    required _i2.EntryType type,
    required double amount,
    required String month,
    required bool recurrent,
    required bool variable,
    required bool confirmed,
    DateTime? dueDate,
    required bool paid,
    DateTime? paidAt,
    double? paidAmount,
    String? paymentMethod,
    String? paymentNote,
  }) = _MonthlyEntryImpl;

  factory MonthlyEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return MonthlyEntry(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      categoryId: jsonSerialization['categoryId'] as int,
      name: jsonSerialization['name'] as String,
      type: _i2.EntryType.fromJson((jsonSerialization['type'] as String)),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      month: jsonSerialization['month'] as String,
      recurrent: _i1.BoolJsonExtension.fromJson(jsonSerialization['recurrent']),
      variable: _i1.BoolJsonExtension.fromJson(jsonSerialization['variable']),
      confirmed: _i1.BoolJsonExtension.fromJson(jsonSerialization['confirmed']),
      dueDate: jsonSerialization['dueDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      paid: _i1.BoolJsonExtension.fromJson(jsonSerialization['paid']),
      paidAt: jsonSerialization['paidAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['paidAt']),
      paidAmount: (jsonSerialization['paidAmount'] as num?)?.toDouble(),
      paymentMethod: jsonSerialization['paymentMethod'] as String?,
      paymentNote: jsonSerialization['paymentNote'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue userId;

  int categoryId;

  String name;

  _i2.EntryType type;

  double amount;

  String month;

  bool recurrent;

  bool variable;

  bool confirmed;

  DateTime? dueDate;

  bool paid;

  DateTime? paidAt;

  double? paidAmount;

  String? paymentMethod;

  String? paymentNote;

  /// Returns a shallow copy of this [MonthlyEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MonthlyEntry copyWith({
    int? id,
    _i1.UuidValue? userId,
    int? categoryId,
    String? name,
    _i2.EntryType? type,
    double? amount,
    String? month,
    bool? recurrent,
    bool? variable,
    bool? confirmed,
    DateTime? dueDate,
    bool? paid,
    DateTime? paidAt,
    double? paidAmount,
    String? paymentMethod,
    String? paymentNote,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MonthlyEntry',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'categoryId': categoryId,
      'name': name,
      'type': type.toJson(),
      'amount': amount,
      'month': month,
      'recurrent': recurrent,
      'variable': variable,
      'confirmed': confirmed,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      'paid': paid,
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
      if (paidAmount != null) 'paidAmount': paidAmount,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (paymentNote != null) 'paymentNote': paymentNote,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MonthlyEntryImpl extends MonthlyEntry {
  _MonthlyEntryImpl({
    int? id,
    required _i1.UuidValue userId,
    required int categoryId,
    required String name,
    required _i2.EntryType type,
    required double amount,
    required String month,
    required bool recurrent,
    required bool variable,
    required bool confirmed,
    DateTime? dueDate,
    required bool paid,
    DateTime? paidAt,
    double? paidAmount,
    String? paymentMethod,
    String? paymentNote,
  }) : super._(
         id: id,
         userId: userId,
         categoryId: categoryId,
         name: name,
         type: type,
         amount: amount,
         month: month,
         recurrent: recurrent,
         variable: variable,
         confirmed: confirmed,
         dueDate: dueDate,
         paid: paid,
         paidAt: paidAt,
         paidAmount: paidAmount,
         paymentMethod: paymentMethod,
         paymentNote: paymentNote,
       );

  /// Returns a shallow copy of this [MonthlyEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MonthlyEntry copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    int? categoryId,
    String? name,
    _i2.EntryType? type,
    double? amount,
    String? month,
    bool? recurrent,
    bool? variable,
    bool? confirmed,
    Object? dueDate = _Undefined,
    bool? paid,
    Object? paidAt = _Undefined,
    Object? paidAmount = _Undefined,
    Object? paymentMethod = _Undefined,
    Object? paymentNote = _Undefined,
  }) {
    return MonthlyEntry(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      month: month ?? this.month,
      recurrent: recurrent ?? this.recurrent,
      variable: variable ?? this.variable,
      confirmed: confirmed ?? this.confirmed,
      dueDate: dueDate is DateTime? ? dueDate : this.dueDate,
      paid: paid ?? this.paid,
      paidAt: paidAt is DateTime? ? paidAt : this.paidAt,
      paidAmount: paidAmount is double? ? paidAmount : this.paidAmount,
      paymentMethod: paymentMethod is String?
          ? paymentMethod
          : this.paymentMethod,
      paymentNote: paymentNote is String? ? paymentNote : this.paymentNote,
    );
  }
}
