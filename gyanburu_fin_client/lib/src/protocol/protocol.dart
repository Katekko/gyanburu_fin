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
import 'attachment.dart' as _i3;
import 'attachment_kind.dart' as _i4;
import 'attachment_upload_ticket.dart' as _i5;
import 'bill.dart' as _i6;
import 'bill_status.dart' as _i7;
import 'budget_category.dart' as _i8;
import 'category.dart' as _i9;
import 'category_rule.dart' as _i10;
import 'chat_message.dart' as _i11;
import 'chat_response.dart' as _i12;
import 'entry_type.dart' as _i13;
import 'financial_transaction.dart' as _i14;
import 'greetings/greeting.dart' as _i15;
import 'import_history.dart' as _i16;
import 'income_source.dart' as _i17;
import 'income_type.dart' as _i18;
import 'monthly_entry.dart' as _i19;
import 'nubank_account.dart' as _i20;
import 'pending_action.dart' as _i21;
import 'sync_log.dart' as _i22;
import 'sync_status.dart' as _i23;
import 'package:gyanburu_fin_client/src/protocol/attachment.dart' as _i24;
import 'package:gyanburu_fin_client/src/protocol/bill.dart' as _i25;
import 'package:gyanburu_fin_client/src/protocol/budget_category.dart' as _i26;
import 'package:gyanburu_fin_client/src/protocol/category.dart' as _i27;
import 'package:gyanburu_fin_client/src/protocol/category_rule.dart' as _i28;
import 'package:gyanburu_fin_client/src/protocol/chat_message.dart' as _i29;
import 'package:gyanburu_fin_client/src/protocol/pending_action.dart' as _i30;
import 'package:gyanburu_fin_client/src/protocol/financial_transaction.dart'
    as _i31;
import 'package:gyanburu_fin_client/src/protocol/import_history.dart' as _i32;
import 'package:gyanburu_fin_client/src/protocol/income_source.dart' as _i33;
import 'package:gyanburu_fin_client/src/protocol/monthly_entry.dart' as _i34;
import 'package:gyanburu_fin_client/src/protocol/nubank_account.dart' as _i35;
import 'package:gyanburu_fin_client/src/protocol/sync_log.dart' as _i36;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i37;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i38;
export 'account_type.dart';
export 'attachment.dart';
export 'attachment_kind.dart';
export 'attachment_upload_ticket.dart';
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
    if (t == _i3.Attachment) {
      return _i3.Attachment.fromJson(data) as T;
    }
    if (t == _i4.AttachmentKind) {
      return _i4.AttachmentKind.fromJson(data) as T;
    }
    if (t == _i5.AttachmentUploadTicket) {
      return _i5.AttachmentUploadTicket.fromJson(data) as T;
    }
    if (t == _i6.Bill) {
      return _i6.Bill.fromJson(data) as T;
    }
    if (t == _i7.BillStatus) {
      return _i7.BillStatus.fromJson(data) as T;
    }
    if (t == _i8.BudgetCategory) {
      return _i8.BudgetCategory.fromJson(data) as T;
    }
    if (t == _i9.Category) {
      return _i9.Category.fromJson(data) as T;
    }
    if (t == _i10.CategoryRule) {
      return _i10.CategoryRule.fromJson(data) as T;
    }
    if (t == _i11.ChatMessage) {
      return _i11.ChatMessage.fromJson(data) as T;
    }
    if (t == _i12.ChatResponse) {
      return _i12.ChatResponse.fromJson(data) as T;
    }
    if (t == _i13.EntryType) {
      return _i13.EntryType.fromJson(data) as T;
    }
    if (t == _i14.FinancialTransaction) {
      return _i14.FinancialTransaction.fromJson(data) as T;
    }
    if (t == _i15.Greeting) {
      return _i15.Greeting.fromJson(data) as T;
    }
    if (t == _i16.ImportHistory) {
      return _i16.ImportHistory.fromJson(data) as T;
    }
    if (t == _i17.IncomeSource) {
      return _i17.IncomeSource.fromJson(data) as T;
    }
    if (t == _i18.IncomeType) {
      return _i18.IncomeType.fromJson(data) as T;
    }
    if (t == _i19.MonthlyEntry) {
      return _i19.MonthlyEntry.fromJson(data) as T;
    }
    if (t == _i20.NubankAccount) {
      return _i20.NubankAccount.fromJson(data) as T;
    }
    if (t == _i21.PendingAction) {
      return _i21.PendingAction.fromJson(data) as T;
    }
    if (t == _i22.SyncLog) {
      return _i22.SyncLog.fromJson(data) as T;
    }
    if (t == _i23.SyncStatus) {
      return _i23.SyncStatus.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AccountType?>()) {
      return (data != null ? _i2.AccountType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Attachment?>()) {
      return (data != null ? _i3.Attachment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AttachmentKind?>()) {
      return (data != null ? _i4.AttachmentKind.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AttachmentUploadTicket?>()) {
      return (data != null ? _i5.AttachmentUploadTicket.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.Bill?>()) {
      return (data != null ? _i6.Bill.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.BillStatus?>()) {
      return (data != null ? _i7.BillStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.BudgetCategory?>()) {
      return (data != null ? _i8.BudgetCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Category?>()) {
      return (data != null ? _i9.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.CategoryRule?>()) {
      return (data != null ? _i10.CategoryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.ChatMessage?>()) {
      return (data != null ? _i11.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ChatResponse?>()) {
      return (data != null ? _i12.ChatResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.EntryType?>()) {
      return (data != null ? _i13.EntryType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.FinancialTransaction?>()) {
      return (data != null ? _i14.FinancialTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.Greeting?>()) {
      return (data != null ? _i15.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.ImportHistory?>()) {
      return (data != null ? _i16.ImportHistory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.IncomeSource?>()) {
      return (data != null ? _i17.IncomeSource.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.IncomeType?>()) {
      return (data != null ? _i18.IncomeType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.MonthlyEntry?>()) {
      return (data != null ? _i19.MonthlyEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.NubankAccount?>()) {
      return (data != null ? _i20.NubankAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.PendingAction?>()) {
      return (data != null ? _i21.PendingAction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.SyncLog?>()) {
      return (data != null ? _i22.SyncLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.SyncStatus?>()) {
      return (data != null ? _i23.SyncStatus.fromJson(data) : null) as T;
    }
    if (t == List<_i21.PendingAction>) {
      return (data as List)
              .map((e) => deserialize<_i21.PendingAction>(e))
              .toList()
          as T;
    }
    if (t == List<_i24.Attachment>) {
      return (data as List).map((e) => deserialize<_i24.Attachment>(e)).toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i25.Bill>) {
      return (data as List).map((e) => deserialize<_i25.Bill>(e)).toList() as T;
    }
    if (t == List<_i26.BudgetCategory>) {
      return (data as List)
              .map((e) => deserialize<_i26.BudgetCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i27.Category>) {
      return (data as List).map((e) => deserialize<_i27.Category>(e)).toList()
          as T;
    }
    if (t == List<_i28.CategoryRule>) {
      return (data as List)
              .map((e) => deserialize<_i28.CategoryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i29.ChatMessage>) {
      return (data as List)
              .map((e) => deserialize<_i29.ChatMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.PendingAction>) {
      return (data as List)
              .map((e) => deserialize<_i30.PendingAction>(e))
              .toList()
          as T;
    }
    if (t == Map<String, double>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<double>(v)),
          )
          as T;
    }
    if (t == List<_i31.FinancialTransaction>) {
      return (data as List)
              .map((e) => deserialize<_i31.FinancialTransaction>(e))
              .toList()
          as T;
    }
    if (t == List<_i32.ImportHistory>) {
      return (data as List)
              .map((e) => deserialize<_i32.ImportHistory>(e))
              .toList()
          as T;
    }
    if (t == List<_i33.IncomeSource>) {
      return (data as List)
              .map((e) => deserialize<_i33.IncomeSource>(e))
              .toList()
          as T;
    }
    if (t == List<_i34.MonthlyEntry>) {
      return (data as List)
              .map((e) => deserialize<_i34.MonthlyEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i35.NubankAccount>) {
      return (data as List)
              .map((e) => deserialize<_i35.NubankAccount>(e))
              .toList()
          as T;
    }
    if (t == List<_i36.SyncLog>) {
      return (data as List).map((e) => deserialize<_i36.SyncLog>(e)).toList()
          as T;
    }
    try {
      return _i37.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i38.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AccountType => 'AccountType',
      _i3.Attachment => 'Attachment',
      _i4.AttachmentKind => 'AttachmentKind',
      _i5.AttachmentUploadTicket => 'AttachmentUploadTicket',
      _i6.Bill => 'Bill',
      _i7.BillStatus => 'BillStatus',
      _i8.BudgetCategory => 'BudgetCategory',
      _i9.Category => 'Category',
      _i10.CategoryRule => 'CategoryRule',
      _i11.ChatMessage => 'ChatMessage',
      _i12.ChatResponse => 'ChatResponse',
      _i13.EntryType => 'EntryType',
      _i14.FinancialTransaction => 'FinancialTransaction',
      _i15.Greeting => 'Greeting',
      _i16.ImportHistory => 'ImportHistory',
      _i17.IncomeSource => 'IncomeSource',
      _i18.IncomeType => 'IncomeType',
      _i19.MonthlyEntry => 'MonthlyEntry',
      _i20.NubankAccount => 'NubankAccount',
      _i21.PendingAction => 'PendingAction',
      _i22.SyncLog => 'SyncLog',
      _i23.SyncStatus => 'SyncStatus',
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
      case _i3.Attachment():
        return 'Attachment';
      case _i4.AttachmentKind():
        return 'AttachmentKind';
      case _i5.AttachmentUploadTicket():
        return 'AttachmentUploadTicket';
      case _i6.Bill():
        return 'Bill';
      case _i7.BillStatus():
        return 'BillStatus';
      case _i8.BudgetCategory():
        return 'BudgetCategory';
      case _i9.Category():
        return 'Category';
      case _i10.CategoryRule():
        return 'CategoryRule';
      case _i11.ChatMessage():
        return 'ChatMessage';
      case _i12.ChatResponse():
        return 'ChatResponse';
      case _i13.EntryType():
        return 'EntryType';
      case _i14.FinancialTransaction():
        return 'FinancialTransaction';
      case _i15.Greeting():
        return 'Greeting';
      case _i16.ImportHistory():
        return 'ImportHistory';
      case _i17.IncomeSource():
        return 'IncomeSource';
      case _i18.IncomeType():
        return 'IncomeType';
      case _i19.MonthlyEntry():
        return 'MonthlyEntry';
      case _i20.NubankAccount():
        return 'NubankAccount';
      case _i21.PendingAction():
        return 'PendingAction';
      case _i22.SyncLog():
        return 'SyncLog';
      case _i23.SyncStatus():
        return 'SyncStatus';
    }
    className = _i37.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i38.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'Attachment') {
      return deserialize<_i3.Attachment>(data['data']);
    }
    if (dataClassName == 'AttachmentKind') {
      return deserialize<_i4.AttachmentKind>(data['data']);
    }
    if (dataClassName == 'AttachmentUploadTicket') {
      return deserialize<_i5.AttachmentUploadTicket>(data['data']);
    }
    if (dataClassName == 'Bill') {
      return deserialize<_i6.Bill>(data['data']);
    }
    if (dataClassName == 'BillStatus') {
      return deserialize<_i7.BillStatus>(data['data']);
    }
    if (dataClassName == 'BudgetCategory') {
      return deserialize<_i8.BudgetCategory>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i9.Category>(data['data']);
    }
    if (dataClassName == 'CategoryRule') {
      return deserialize<_i10.CategoryRule>(data['data']);
    }
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i11.ChatMessage>(data['data']);
    }
    if (dataClassName == 'ChatResponse') {
      return deserialize<_i12.ChatResponse>(data['data']);
    }
    if (dataClassName == 'EntryType') {
      return deserialize<_i13.EntryType>(data['data']);
    }
    if (dataClassName == 'FinancialTransaction') {
      return deserialize<_i14.FinancialTransaction>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i15.Greeting>(data['data']);
    }
    if (dataClassName == 'ImportHistory') {
      return deserialize<_i16.ImportHistory>(data['data']);
    }
    if (dataClassName == 'IncomeSource') {
      return deserialize<_i17.IncomeSource>(data['data']);
    }
    if (dataClassName == 'IncomeType') {
      return deserialize<_i18.IncomeType>(data['data']);
    }
    if (dataClassName == 'MonthlyEntry') {
      return deserialize<_i19.MonthlyEntry>(data['data']);
    }
    if (dataClassName == 'NubankAccount') {
      return deserialize<_i20.NubankAccount>(data['data']);
    }
    if (dataClassName == 'PendingAction') {
      return deserialize<_i21.PendingAction>(data['data']);
    }
    if (dataClassName == 'SyncLog') {
      return deserialize<_i22.SyncLog>(data['data']);
    }
    if (dataClassName == 'SyncStatus') {
      return deserialize<_i23.SyncStatus>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i37.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i38.Protocol().deserializeByClassName(data);
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
      return _i37.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i38.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
