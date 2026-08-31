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
import 'package:serverpod/serverpod.dart' as _i1;
import 'benefit_wallet.dart' as _i2;
import 'package:gyanburu_fin_server/src/generated/protocol.dart' as _i3;

abstract class WalletSummary
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  WalletSummary._({
    required this.wallet,
    required this.balance,
    required this.month,
    required this.monthSpent,
    required this.monthToppedUp,
  });

  factory WalletSummary({
    required _i2.BenefitWallet wallet,
    required double balance,
    required String month,
    required double monthSpent,
    required double monthToppedUp,
  }) = _WalletSummaryImpl;

  factory WalletSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return WalletSummary(
      wallet: _i3.Protocol().deserialize<_i2.BenefitWallet>(
        jsonSerialization['wallet'],
      ),
      balance: (jsonSerialization['balance'] as num).toDouble(),
      month: jsonSerialization['month'] as String,
      monthSpent: (jsonSerialization['monthSpent'] as num).toDouble(),
      monthToppedUp: (jsonSerialization['monthToppedUp'] as num).toDouble(),
    );
  }

  _i2.BenefitWallet wallet;

  double balance;

  String month;

  double monthSpent;

  double monthToppedUp;

  /// Returns a shallow copy of this [WalletSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WalletSummary copyWith({
    _i2.BenefitWallet? wallet,
    double? balance,
    String? month,
    double? monthSpent,
    double? monthToppedUp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WalletSummary',
      'wallet': wallet.toJson(),
      'balance': balance,
      'month': month,
      'monthSpent': monthSpent,
      'monthToppedUp': monthToppedUp,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WalletSummary',
      'wallet': wallet.toJsonForProtocol(),
      'balance': balance,
      'month': month,
      'monthSpent': monthSpent,
      'monthToppedUp': monthToppedUp,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _WalletSummaryImpl extends WalletSummary {
  _WalletSummaryImpl({
    required _i2.BenefitWallet wallet,
    required double balance,
    required String month,
    required double monthSpent,
    required double monthToppedUp,
  }) : super._(
         wallet: wallet,
         balance: balance,
         month: month,
         monthSpent: monthSpent,
         monthToppedUp: monthToppedUp,
       );

  /// Returns a shallow copy of this [WalletSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WalletSummary copyWith({
    _i2.BenefitWallet? wallet,
    double? balance,
    String? month,
    double? monthSpent,
    double? monthToppedUp,
  }) {
    return WalletSummary(
      wallet: wallet ?? this.wallet.copyWith(),
      balance: balance ?? this.balance,
      month: month ?? this.month,
      monthSpent: monthSpent ?? this.monthSpent,
      monthToppedUp: monthToppedUp ?? this.monthToppedUp,
    );
  }
}
