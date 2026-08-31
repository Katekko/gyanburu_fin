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

abstract class BenefitWallet implements _i1.SerializableModel {
  BenefitWallet._({
    this.id,
    required this.userId,
    required this.provider,
    required this.slug,
    required this.name,
    required this.anchorBalance,
    required this.anchorDate,
    this.monthlyTopupAmount,
  });

  factory BenefitWallet({
    int? id,
    required _i1.UuidValue userId,
    required String provider,
    required String slug,
    required String name,
    required double anchorBalance,
    required DateTime anchorDate,
    double? monthlyTopupAmount,
  }) = _BenefitWalletImpl;

  factory BenefitWallet.fromJson(Map<String, dynamic> jsonSerialization) {
    return BenefitWallet(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      provider: jsonSerialization['provider'] as String,
      slug: jsonSerialization['slug'] as String,
      name: jsonSerialization['name'] as String,
      anchorBalance: (jsonSerialization['anchorBalance'] as num).toDouble(),
      anchorDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['anchorDate'],
      ),
      monthlyTopupAmount: (jsonSerialization['monthlyTopupAmount'] as num?)
          ?.toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue userId;

  String provider;

  String slug;

  String name;

  double anchorBalance;

  DateTime anchorDate;

  double? monthlyTopupAmount;

  /// Returns a shallow copy of this [BenefitWallet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BenefitWallet copyWith({
    int? id,
    _i1.UuidValue? userId,
    String? provider,
    String? slug,
    String? name,
    double? anchorBalance,
    DateTime? anchorDate,
    double? monthlyTopupAmount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BenefitWallet',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'provider': provider,
      'slug': slug,
      'name': name,
      'anchorBalance': anchorBalance,
      'anchorDate': anchorDate.toJson(),
      if (monthlyTopupAmount != null) 'monthlyTopupAmount': monthlyTopupAmount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BenefitWalletImpl extends BenefitWallet {
  _BenefitWalletImpl({
    int? id,
    required _i1.UuidValue userId,
    required String provider,
    required String slug,
    required String name,
    required double anchorBalance,
    required DateTime anchorDate,
    double? monthlyTopupAmount,
  }) : super._(
         id: id,
         userId: userId,
         provider: provider,
         slug: slug,
         name: name,
         anchorBalance: anchorBalance,
         anchorDate: anchorDate,
         monthlyTopupAmount: monthlyTopupAmount,
       );

  /// Returns a shallow copy of this [BenefitWallet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BenefitWallet copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? provider,
    String? slug,
    String? name,
    double? anchorBalance,
    DateTime? anchorDate,
    Object? monthlyTopupAmount = _Undefined,
  }) {
    return BenefitWallet(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      provider: provider ?? this.provider,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      anchorBalance: anchorBalance ?? this.anchorBalance,
      anchorDate: anchorDate ?? this.anchorDate,
      monthlyTopupAmount: monthlyTopupAmount is double?
          ? monthlyTopupAmount
          : this.monthlyTopupAmount,
    );
  }
}
