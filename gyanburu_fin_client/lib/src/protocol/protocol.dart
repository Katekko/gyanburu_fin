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
import 'category_rule.dart' as _i7;
import 'chat_message.dart' as _i8;
import 'chat_response.dart' as _i9;
import 'entry_type.dart' as _i10;
import 'financial_transaction.dart' as _i11;
import 'greetings/greeting.dart' as _i12;
import 'import_history.dart' as _i13;
import 'income_source.dart' as _i14;
import 'income_type.dart' as _i15;
import 'monthly_entry.dart' as _i16;
import 'nubank_account.dart' as _i17;
import 'pending_action.dart' as _i18;
import 'sync_log.dart' as _i19;
import 'sync_status.dart' as _i20;
import 'package:gyanburu_fin_client/src/protocol/bill.dart' as _i21;
import 'package:gyanburu_fin_client/src/protocol/budget_category.dart' as _i22;
import 'package:gyanburu_fin_client/src/protocol/category.dart' as _i23;
import 'package:gyanburu_fin_client/src/protocol/category_rule.dart' as _i24;
import 'package:gyanburu_fin_client/src/protocol/chat_message.dart' as _i25;
import 'package:gyanburu_fin_client/src/protocol/pending_action.dart' as _i26;
import 'package:gyanburu_fin_client/src/protocol/financial_transaction.dart'
    as _i27;
import 'package:gyanburu_fin_client/src/protocol/import_history.dart' as _i28;
import 'package:gyanburu_fin_client/src/protocol/income_source.dart' as _i29;
import 'package:gyanburu_fin_client/src/protocol/monthly_entry.dart' as _i30;
import 'package:gyanburu_fin_client/src/protocol/nubank_account.dart' as _i31;
import 'package:gyanburu_fin_client/src/protocol/sync_log.dart' as _i32;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i33;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i34;
export 'account_type.dart';
export 'bill.dart';
export 'bill_status.dart';
export 'budget_category.dart';
export 'category.dart';
export 'category_rule.dart';
export 'chat_message.dart';
export 'chat_response.dart';
export 'entry_type.dart';
export 'financial_transaction.dart';
export 'greetings/greeting.dart';
export 'import_history.dart';
export 'income_source.dart';
export 'income_type.dart';
export 'monthly_entry.dart';
export 'nubank_account.dart';
export 'pending_action.dart';
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
    if (t == _i7.CategoryRule) {
      return _i7.CategoryRule.fromJson(data) as T;
    }
    if (t == _i8.ChatMessage) {
      return _i8.ChatMessage.fromJson(data) as T;
    }
    if (t == _i9.ChatResponse) {
      return _i9.ChatResponse.fromJson(data) as T;
    }
    if (t == _i10.EntryType) {
      return _i10.EntryType.fromJson(data) as T;
    }
    if (t == _i11.FinancialTransaction) {
      return _i11.FinancialTransaction.fromJson(data) as T;
    }
    if (t == _i12.Greeting) {
      return _i12.Greeting.fromJson(data) as T;
    }
    if (t == _i13.ImportHistory) {
      return _i13.ImportHistory.fromJson(data) as T;
    }
    if (t == _i14.IncomeSource) {
      return _i14.IncomeSource.fromJson(data) as T;
    }
    if (t == _i15.IncomeType) {
      return _i15.IncomeType.fromJson(data) as T;
    }
    if (t == _i16.MonthlyEntry) {
      return _i16.MonthlyEntry.fromJson(data) as T;
    }
    if (t == _i17.NubankAccount) {
      return _i17.NubankAccount.fromJson(data) as T;
    }
    if (t == _i18.PendingAction) {
      return _i18.PendingAction.fromJson(data) as T;
    }
    if (t == _i19.SyncLog) {
      return _i19.SyncLog.fromJson(data) as T;
    }
    if (t == _i20.SyncStatus) {
      return _i20.SyncStatus.fromJson(data) as T;
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
    if (t == _i1.getType<_i7.CategoryRule?>()) {
      return (data != null ? _i7.CategoryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ChatMessage?>()) {
      return (data != null ? _i8.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.ChatResponse?>()) {
      return (data != null ? _i9.ChatResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.EntryType?>()) {
      return (data != null ? _i10.EntryType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.FinancialTransaction?>()) {
      return (data != null ? _i11.FinancialTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.Greeting?>()) {
      return (data != null ? _i12.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.ImportHistory?>()) {
      return (data != null ? _i13.ImportHistory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.IncomeSource?>()) {
      return (data != null ? _i14.IncomeSource.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.IncomeType?>()) {
      return (data != null ? _i15.IncomeType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.MonthlyEntry?>()) {
      return (data != null ? _i16.MonthlyEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.NubankAccount?>()) {
      return (data != null ? _i17.NubankAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.PendingAction?>()) {
      return (data != null ? _i18.PendingAction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.SyncLog?>()) {
      return (data != null ? _i19.SyncLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.SyncStatus?>()) {
      return (data != null ? _i20.SyncStatus.fromJson(data) : null) as T;
    }
    if (t == List<_i18.PendingAction>) {
      return (data as List)
              .map((e) => deserialize<_i18.PendingAction>(e))
              .toList()
          as T;
    }
    if (t == List<_i21.Bill>) {
      return (data as List).map((e) => deserialize<_i21.Bill>(e)).toList() as T;
    }
    if (t == List<_i22.BudgetCategory>) {
      return (data as List)
              .map((e) => deserialize<_i22.BudgetCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.Category>) {
      return (data as List).map((e) => deserialize<_i23.Category>(e)).toList()
          as T;
    }
    if (t == List<_i24.CategoryRule>) {
      return (data as List)
              .map((e) => deserialize<_i24.CategoryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i25.ChatMessage>) {
      return (data as List)
              .map((e) => deserialize<_i25.ChatMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_i26.PendingAction>) {
      return (data as List)
              .map((e) => deserialize<_i26.PendingAction>(e))
              .toList()
          as T;
    }
    if (t == Map<String, double>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<double>(v)),
          )
          as T;
    }
    if (t == List<_i27.FinancialTransaction>) {
      return (data as List)
              .map((e) => deserialize<_i27.FinancialTransaction>(e))
              .toList()
          as T;
    }
    if (t == List<_i28.ImportHistory>) {
      return (data as List)
              .map((e) => deserialize<_i28.ImportHistory>(e))
              .toList()
          as T;
    }
    if (t == List<_i29.IncomeSource>) {
      return (data as List)
              .map((e) => deserialize<_i29.IncomeSource>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.MonthlyEntry>) {
      return (data as List)
              .map((e) => deserialize<_i30.MonthlyEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i31.NubankAccount>) {
      return (data as List)
              .map((e) => deserialize<_i31.NubankAccount>(e))
              .toList()
          as T;
    }
    if (t == List<_i32.SyncLog>) {
      return (data as List).map((e) => deserialize<_i32.SyncLog>(e)).toList()
          as T;
    }
    try {
      return _i33.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i34.Protocol().deserialize<T>(data, t);
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
      _i7.CategoryRule => 'CategoryRule',
      _i8.ChatMessage => 'ChatMessage',
      _i9.ChatResponse => 'ChatResponse',
      _i10.EntryType => 'EntryType',
      _i11.FinancialTransaction => 'FinancialTransaction',
      _i12.Greeting => 'Greeting',
      _i13.ImportHistory => 'ImportHistory',
      _i14.IncomeSource => 'IncomeSource',
      _i15.IncomeType => 'IncomeType',
      _i16.MonthlyEntry => 'MonthlyEntry',
      _i17.NubankAccount => 'NubankAccount',
      _i18.PendingAction => 'PendingAction',
      _i19.SyncLog => 'SyncLog',
      _i20.SyncStatus => 'SyncStatus',
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
      case _i7.CategoryRule():
        return 'CategoryRule';
      case _i8.ChatMessage():
        return 'ChatMessage';
      case _i9.ChatResponse():
        return 'ChatResponse';
      case _i10.EntryType():
        return 'EntryType';
      case _i11.FinancialTransaction():
        return 'FinancialTransaction';
      case _i12.Greeting():
        return 'Greeting';
      case _i13.ImportHistory():
        return 'ImportHistory';
      case _i14.IncomeSource():
        return 'IncomeSource';
      case _i15.IncomeType():
        return 'IncomeType';
      case _i16.MonthlyEntry():
        return 'MonthlyEntry';
      case _i17.NubankAccount():
        return 'NubankAccount';
      case _i18.PendingAction():
        return 'PendingAction';
      case _i19.SyncLog():
        return 'SyncLog';
      case _i20.SyncStatus():
        return 'SyncStatus';
    }
    className = _i33.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i34.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'CategoryRule') {
      return deserialize<_i7.CategoryRule>(data['data']);
    }
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i8.ChatMessage>(data['data']);
    }
    if (dataClassName == 'ChatResponse') {
      return deserialize<_i9.ChatResponse>(data['data']);
    }
    if (dataClassName == 'EntryType') {
      return deserialize<_i10.EntryType>(data['data']);
    }
    if (dataClassName == 'FinancialTransaction') {
      return deserialize<_i11.FinancialTransaction>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i12.Greeting>(data['data']);
    }
    if (dataClassName == 'ImportHistory') {
      return deserialize<_i13.ImportHistory>(data['data']);
    }
    if (dataClassName == 'IncomeSource') {
      return deserialize<_i14.IncomeSource>(data['data']);
    }
    if (dataClassName == 'IncomeType') {
      return deserialize<_i15.IncomeType>(data['data']);
    }
    if (dataClassName == 'MonthlyEntry') {
      return deserialize<_i16.MonthlyEntry>(data['data']);
    }
    if (dataClassName == 'NubankAccount') {
      return deserialize<_i17.NubankAccount>(data['data']);
    }
    if (dataClassName == 'PendingAction') {
      return deserialize<_i18.PendingAction>(data['data']);
    }
    if (dataClassName == 'SyncLog') {
      return deserialize<_i19.SyncLog>(data['data']);
    }
    if (dataClassName == 'SyncStatus') {
      return deserialize<_i20.SyncStatus>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i33.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i34.Protocol().deserializeByClassName(data);
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
      return _i33.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i34.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
