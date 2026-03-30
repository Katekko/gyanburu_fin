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
import 'bill.dart' as _i3;
import 'bill_status.dart' as _i4;
import 'budget_category.dart' as _i5;
import 'category.dart' as _i6;
import 'entry_type.dart' as _i7;
import 'financial_transaction.dart' as _i8;
import 'greetings/greeting.dart' as _i9;
import 'income_source.dart' as _i10;
import 'income_type.dart' as _i11;
import 'monthly_entry.dart' as _i12;
import 'nubank_account.dart' as _i13;
import 'sync_log.dart' as _i14;
import 'sync_status.dart' as _i15;
import 'package:gyanburu_fin_client/src/protocol/bill.dart' as _i16;
import 'package:gyanburu_fin_client/src/protocol/budget_category.dart' as _i17;
import 'package:gyanburu_fin_client/src/protocol/category.dart' as _i18;
import 'package:gyanburu_fin_client/src/protocol/financial_transaction.dart'
    as _i19;
import 'package:gyanburu_fin_client/src/protocol/income_source.dart' as _i20;
import 'package:gyanburu_fin_client/src/protocol/monthly_entry.dart' as _i21;
import 'package:gyanburu_fin_client/src/protocol/nubank_account.dart' as _i22;
import 'package:gyanburu_fin_client/src/protocol/sync_log.dart' as _i23;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i24;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i25;
export 'account_type.dart';
export 'bill.dart';
export 'bill_status.dart';
export 'budget_category.dart';
export 'category.dart';
export 'entry_type.dart';
export 'financial_transaction.dart';
export 'greetings/greeting.dart';
export 'income_source.dart';
export 'income_type.dart';
export 'monthly_entry.dart';
export 'nubank_account.dart';
export 'sync_log.dart';
export 'sync_status.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.AccountType) {
      return _i2.AccountType.fromJson(data) as T;
    }
    if (t == _i3.Bill) {
      return _i3.Bill.fromJson(data) as T;
    }
    if (t == _i4.BillStatus) {
      return _i4.BillStatus.fromJson(data) as T;
    }
    if (t == _i5.BudgetCategory) {
      return _i5.BudgetCategory.fromJson(data) as T;
    }
    if (t == _i6.Category) {
      return _i6.Category.fromJson(data) as T;
    }
    if (t == _i7.EntryType) {
      return _i7.EntryType.fromJson(data) as T;
    }
    if (t == _i8.FinancialTransaction) {
      return _i8.FinancialTransaction.fromJson(data) as T;
    }
    if (t == _i9.Greeting) {
      return _i9.Greeting.fromJson(data) as T;
    }
    if (t == _i10.IncomeSource) {
      return _i10.IncomeSource.fromJson(data) as T;
    }
    if (t == _i11.IncomeType) {
      return _i11.IncomeType.fromJson(data) as T;
    }
    if (t == _i12.MonthlyEntry) {
      return _i12.MonthlyEntry.fromJson(data) as T;
    }
    if (t == _i13.NubankAccount) {
      return _i13.NubankAccount.fromJson(data) as T;
    }
    if (t == _i14.SyncLog) {
      return _i14.SyncLog.fromJson(data) as T;
    }
    if (t == _i15.SyncStatus) {
      return _i15.SyncStatus.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AccountType?>()) {
      return (data != null ? _i2.AccountType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Bill?>()) {
      return (data != null ? _i3.Bill.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.BillStatus?>()) {
      return (data != null ? _i4.BillStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.BudgetCategory?>()) {
      return (data != null ? _i5.BudgetCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Category?>()) {
      return (data != null ? _i6.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.EntryType?>()) {
      return (data != null ? _i7.EntryType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.FinancialTransaction?>()) {
      return (data != null ? _i8.FinancialTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.Greeting?>()) {
      return (data != null ? _i9.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.IncomeSource?>()) {
      return (data != null ? _i10.IncomeSource.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.IncomeType?>()) {
      return (data != null ? _i11.IncomeType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.MonthlyEntry?>()) {
      return (data != null ? _i12.MonthlyEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.NubankAccount?>()) {
      return (data != null ? _i13.NubankAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.SyncLog?>()) {
      return (data != null ? _i14.SyncLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.SyncStatus?>()) {
      return (data != null ? _i15.SyncStatus.fromJson(data) : null) as T;
    }
    if (t == List<_i16.Bill>) {
      return (data as List).map((e) => deserialize<_i16.Bill>(e)).toList() as T;
    }
    if (t == List<_i17.BudgetCategory>) {
      return (data as List)
              .map((e) => deserialize<_i17.BudgetCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i18.Category>) {
      return (data as List).map((e) => deserialize<_i18.Category>(e)).toList()
          as T;
    }
    if (t == Map<String, double>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<double>(v)),
          )
          as T;
    }
    if (t == List<_i19.FinancialTransaction>) {
      return (data as List)
              .map((e) => deserialize<_i19.FinancialTransaction>(e))
              .toList()
          as T;
    }
    if (t == List<_i20.IncomeSource>) {
      return (data as List)
              .map((e) => deserialize<_i20.IncomeSource>(e))
              .toList()
          as T;
    }
    if (t == List<_i21.MonthlyEntry>) {
      return (data as List)
              .map((e) => deserialize<_i21.MonthlyEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i22.NubankAccount>) {
      return (data as List)
              .map((e) => deserialize<_i22.NubankAccount>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.SyncLog>) {
      return (data as List).map((e) => deserialize<_i23.SyncLog>(e)).toList()
          as T;
    }
    try {
      return _i24.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i25.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AccountType => 'AccountType',
      _i3.Bill => 'Bill',
      _i4.BillStatus => 'BillStatus',
      _i5.BudgetCategory => 'BudgetCategory',
      _i6.Category => 'Category',
      _i7.EntryType => 'EntryType',
      _i8.FinancialTransaction => 'FinancialTransaction',
      _i9.Greeting => 'Greeting',
      _i10.IncomeSource => 'IncomeSource',
      _i11.IncomeType => 'IncomeType',
      _i12.MonthlyEntry => 'MonthlyEntry',
      _i13.NubankAccount => 'NubankAccount',
      _i14.SyncLog => 'SyncLog',
      _i15.SyncStatus => 'SyncStatus',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'gyanburu_fin.',
        '',
      );
    }

    switch (data) {
      case _i2.AccountType():
        return 'AccountType';
      case _i3.Bill():
        return 'Bill';
      case _i4.BillStatus():
        return 'BillStatus';
      case _i5.BudgetCategory():
        return 'BudgetCategory';
      case _i6.Category():
        return 'Category';
      case _i7.EntryType():
        return 'EntryType';
      case _i8.FinancialTransaction():
        return 'FinancialTransaction';
      case _i9.Greeting():
        return 'Greeting';
      case _i10.IncomeSource():
        return 'IncomeSource';
      case _i11.IncomeType():
        return 'IncomeType';
      case _i12.MonthlyEntry():
        return 'MonthlyEntry';
      case _i13.NubankAccount():
        return 'NubankAccount';
      case _i14.SyncLog():
        return 'SyncLog';
      case _i15.SyncStatus():
        return 'SyncStatus';
    }
    className = _i24.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i25.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AccountType') {
      return deserialize<_i2.AccountType>(data['data']);
    }
    if (dataClassName == 'Bill') {
      return deserialize<_i3.Bill>(data['data']);
    }
    if (dataClassName == 'BillStatus') {
      return deserialize<_i4.BillStatus>(data['data']);
    }
    if (dataClassName == 'BudgetCategory') {
      return deserialize<_i5.BudgetCategory>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i6.Category>(data['data']);
    }
    if (dataClassName == 'EntryType') {
      return deserialize<_i7.EntryType>(data['data']);
    }
    if (dataClassName == 'FinancialTransaction') {
      return deserialize<_i8.FinancialTransaction>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i9.Greeting>(data['data']);
    }
    if (dataClassName == 'IncomeSource') {
      return deserialize<_i10.IncomeSource>(data['data']);
    }
    if (dataClassName == 'IncomeType') {
      return deserialize<_i11.IncomeType>(data['data']);
    }
    if (dataClassName == 'MonthlyEntry') {
      return deserialize<_i12.MonthlyEntry>(data['data']);
    }
    if (dataClassName == 'NubankAccount') {
      return deserialize<_i13.NubankAccount>(data['data']);
    }
    if (dataClassName == 'SyncLog') {
      return deserialize<_i14.SyncLog>(data['data']);
    }
    if (dataClassName == 'SyncStatus') {
      return deserialize<_i15.SyncStatus>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i24.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i25.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i24.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i25.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
