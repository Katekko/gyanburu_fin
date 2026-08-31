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
import 'dart:async' as _i2;
import 'package:gyanburu_fin_client/src/protocol/attachment_upload_ticket.dart'
    as _i3;
import 'package:gyanburu_fin_client/src/protocol/attachment_kind.dart' as _i4;
import 'package:gyanburu_fin_client/src/protocol/attachment.dart' as _i5;
import 'dart:typed_data' as _i6;
import 'package:gyanburu_fin_client/src/protocol/bill.dart' as _i7;
import 'package:gyanburu_fin_client/src/protocol/budget_category.dart' as _i8;
import 'package:gyanburu_fin_client/src/protocol/category.dart' as _i9;
import 'package:gyanburu_fin_client/src/protocol/category_rule.dart' as _i10;
import 'package:gyanburu_fin_client/src/protocol/chat_response.dart' as _i11;
import 'package:gyanburu_fin_client/src/protocol/chat_message.dart' as _i12;
import 'package:gyanburu_fin_client/src/protocol/pending_action.dart' as _i13;
import 'package:gyanburu_fin_client/src/protocol/financial_transaction.dart'
    as _i14;
import 'package:gyanburu_fin_client/src/protocol/import_history.dart' as _i15;
import 'package:gyanburu_fin_client/src/protocol/income_source.dart' as _i16;
import 'package:gyanburu_fin_client/src/protocol/monthly_entry.dart' as _i17;
import 'package:gyanburu_fin_client/src/protocol/nubank_account.dart' as _i18;
import 'package:gyanburu_fin_client/src/protocol/sync_log.dart' as _i19;
import 'package:gyanburu_fin_client/src/protocol/wallet_summary.dart' as _i20;
import 'package:gyanburu_fin_client/src/protocol/benefit_wallet.dart' as _i21;
import 'package:gyanburu_fin_client/src/protocol/greetings/greeting.dart'
    as _i22;
import 'protocol.dart' as _i23;

/// Manages payment documents (boletos and receipts) attached to a
/// [MonthlyEntry]. Files live in Serverpod's built-in `private` cloud storage
/// and are only ever served back to their owner through [getData].
/// {@category Endpoint}
class EndpointAttachment extends _i1.EndpointRef {
  EndpointAttachment(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'attachment';

  /// Step 1 of upload: verify ownership and hand the client a direct-upload
  /// description plus the storage path it must echo back to [confirmUpload].
  _i2.Future<_i3.AttachmentUploadTicket> requestUpload(
    int entryId,
    _i4.AttachmentKind kind,
    String fileName,
    int contentLength,
  ) => caller.callServerEndpoint<_i3.AttachmentUploadTicket>(
    'attachment',
    'requestUpload',
    {
      'entryId': entryId,
      'kind': kind,
      'fileName': fileName,
      'contentLength': contentLength,
    },
  );

  /// Step 2 of upload: confirm the file landed in storage and record it.
  _i2.Future<_i5.Attachment> confirmUpload(
    int entryId,
    _i4.AttachmentKind kind,
    String path,
    String fileName,
    String contentType,
    int sizeBytes,
  ) => caller.callServerEndpoint<_i5.Attachment>(
    'attachment',
    'confirmUpload',
    {
      'entryId': entryId,
      'kind': kind,
      'path': path,
      'fileName': fileName,
      'contentType': contentType,
      'sizeBytes': sizeBytes,
    },
  );

  _i2.Future<List<_i5.Attachment>> listForEntry(int entryId) =>
      caller.callServerEndpoint<List<_i5.Attachment>>(
        'attachment',
        'listForEntry',
        {'entryId': entryId},
      );

  /// Returns the subset of [entryIds] (owned by the user) that have at least
  /// one attachment — used to show an indicator on bill rows in one round trip.
  _i2.Future<List<int>> entryIdsWithAttachments(List<int> entryIds) =>
      caller.callServerEndpoint<List<int>>(
        'attachment',
        'entryIdsWithAttachments',
        {'entryIds': entryIds},
      );

  _i2.Future<_i6.ByteData?> getData(int attachmentId) =>
      caller.callServerEndpoint<_i6.ByteData?>(
        'attachment',
        'getData',
        {'attachmentId': attachmentId},
      );

  _i2.Future<void> deleteAttachment(int attachmentId) =>
      caller.callServerEndpoint<void>(
        'attachment',
        'deleteAttachment',
        {'attachmentId': attachmentId},
      );
}

/// {@category Endpoint}
class EndpointBill extends _i1.EndpointRef {
  EndpointBill(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'bill';

  _i2.Future<List<_i7.Bill>> list() =>
      caller.callServerEndpoint<List<_i7.Bill>>(
        'bill',
        'list',
        {},
      );

  _i2.Future<List<_i7.Bill>> listUpcoming() =>
      caller.callServerEndpoint<List<_i7.Bill>>(
        'bill',
        'listUpcoming',
        {},
      );

  _i2.Future<_i7.Bill> create(_i7.Bill bill) =>
      caller.callServerEndpoint<_i7.Bill>(
        'bill',
        'create',
        {'bill': bill},
      );

  _i2.Future<_i7.Bill> update(_i7.Bill bill) =>
      caller.callServerEndpoint<_i7.Bill>(
        'bill',
        'update',
        {'bill': bill},
      );

  _i2.Future<_i7.Bill> markAsPaid(int id) =>
      caller.callServerEndpoint<_i7.Bill>(
        'bill',
        'markAsPaid',
        {'id': id},
      );

  _i2.Future<void> delete(int id) => caller.callServerEndpoint<void>(
    'bill',
    'delete',
    {'id': id},
  );
}

/// {@category Endpoint}
class EndpointBudget extends _i1.EndpointRef {
  EndpointBudget(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'budget';

  _i2.Future<List<_i8.BudgetCategory>> listByMonth(DateTime month) =>
      caller.callServerEndpoint<List<_i8.BudgetCategory>>(
        'budget',
        'listByMonth',
        {'month': month},
      );

  _i2.Future<_i8.BudgetCategory> create(_i8.BudgetCategory category) =>
      caller.callServerEndpoint<_i8.BudgetCategory>(
        'budget',
        'create',
        {'category': category},
      );

  _i2.Future<_i8.BudgetCategory> update(_i8.BudgetCategory category) =>
      caller.callServerEndpoint<_i8.BudgetCategory>(
        'budget',
        'update',
        {'category': category},
      );

  _i2.Future<void> delete(int id) => caller.callServerEndpoint<void>(
    'budget',
    'delete',
    {'id': id},
  );
}

/// {@category Endpoint}
class EndpointCategory extends _i1.EndpointRef {
  EndpointCategory(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'category';

  _i2.Future<List<_i9.Category>> list() =>
      caller.callServerEndpoint<List<_i9.Category>>(
        'category',
        'list',
        {},
      );

  _i2.Future<_i9.Category> create(_i9.Category category) =>
      caller.callServerEndpoint<_i9.Category>(
        'category',
        'create',
        {'category': category},
      );

  _i2.Future<_i9.Category> update(_i9.Category category) =>
      caller.callServerEndpoint<_i9.Category>(
        'category',
        'update',
        {'category': category},
      );

  _i2.Future<void> delete(int id) => caller.callServerEndpoint<void>(
    'category',
    'delete',
    {'id': id},
  );
}

/// {@category Endpoint}
class EndpointCategoryRule extends _i1.EndpointRef {
  EndpointCategoryRule(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'categoryRule';

  _i2.Future<List<_i10.CategoryRule>> list() =>
      caller.callServerEndpoint<List<_i10.CategoryRule>>(
        'categoryRule',
        'list',
        {},
      );

  _i2.Future<_i10.CategoryRule> create(_i10.CategoryRule rule) =>
      caller.callServerEndpoint<_i10.CategoryRule>(
        'categoryRule',
        'create',
        {'rule': rule},
      );

  _i2.Future<_i10.CategoryRule> update(_i10.CategoryRule rule) =>
      caller.callServerEndpoint<_i10.CategoryRule>(
        'categoryRule',
        'update',
        {'rule': rule},
      );

  _i2.Future<void> delete(int id) => caller.callServerEndpoint<void>(
    'categoryRule',
    'delete',
    {'id': id},
  );
}

/// {@category Endpoint}
class EndpointChat extends _i1.EndpointRef {
  EndpointChat(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'chat';

  _i2.Future<_i11.ChatResponse> sendMessage(
    List<_i12.ChatMessage> history,
    String userMessage,
  ) => caller.callServerEndpoint<_i11.ChatResponse>(
    'chat',
    'sendMessage',
    {
      'history': history,
      'userMessage': userMessage,
    },
  );

  _i2.Future<String> executeActions(List<_i13.PendingAction> actions) =>
      caller.callServerEndpoint<String>(
        'chat',
        'executeActions',
        {'actions': actions},
      );
}

/// {@category Endpoint}
class EndpointDashboard extends _i1.EndpointRef {
  EndpointDashboard(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'dashboard';

  _i2.Future<Map<String, double>> spendingByCategory(DateTime month) =>
      caller.callServerEndpoint<Map<String, double>>(
        'dashboard',
        'spendingByCategory',
        {'month': month},
      );

  _i2.Future<List<_i14.FinancialTransaction>> recentTransactions() =>
      caller.callServerEndpoint<List<_i14.FinancialTransaction>>(
        'dashboard',
        'recentTransactions',
        {},
      );

  _i2.Future<double> netBalance(DateTime month) =>
      caller.callServerEndpoint<double>(
        'dashboard',
        'netBalance',
        {'month': month},
      );
}

/// {@category Endpoint}
class EndpointImportHistory extends _i1.EndpointRef {
  EndpointImportHistory(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'importHistory';

  _i2.Future<List<_i15.ImportHistory>> list() =>
      caller.callServerEndpoint<List<_i15.ImportHistory>>(
        'importHistory',
        'list',
        {},
      );
}

/// {@category Endpoint}
class EndpointIncome extends _i1.EndpointRef {
  EndpointIncome(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'income';

  _i2.Future<List<_i16.IncomeSource>> listByMonth(DateTime month) =>
      caller.callServerEndpoint<List<_i16.IncomeSource>>(
        'income',
        'listByMonth',
        {'month': month},
      );

  _i2.Future<_i16.IncomeSource> create(_i16.IncomeSource source) =>
      caller.callServerEndpoint<_i16.IncomeSource>(
        'income',
        'create',
        {'source': source},
      );

  _i2.Future<_i16.IncomeSource> update(_i16.IncomeSource source) =>
      caller.callServerEndpoint<_i16.IncomeSource>(
        'income',
        'update',
        {'source': source},
      );

  _i2.Future<void> delete(int id) => caller.callServerEndpoint<void>(
    'income',
    'delete',
    {'id': id},
  );
}

/// {@category Endpoint}
class EndpointMonthlyEntry extends _i1.EndpointRef {
  EndpointMonthlyEntry(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'monthlyEntry';

  _i2.Future<List<_i17.MonthlyEntry>> listByMonth(String month) =>
      caller.callServerEndpoint<List<_i17.MonthlyEntry>>(
        'monthlyEntry',
        'listByMonth',
        {'month': month},
      );

  _i2.Future<_i17.MonthlyEntry> create(_i17.MonthlyEntry entry) =>
      caller.callServerEndpoint<_i17.MonthlyEntry>(
        'monthlyEntry',
        'create',
        {'entry': entry},
      );

  _i2.Future<_i17.MonthlyEntry> update(_i17.MonthlyEntry entry) =>
      caller.callServerEndpoint<_i17.MonthlyEntry>(
        'monthlyEntry',
        'update',
        {'entry': entry},
      );

  _i2.Future<void> delete(int id) => caller.callServerEndpoint<void>(
    'monthlyEntry',
    'delete',
    {'id': id},
  );
}

/// {@category Endpoint}
class EndpointNubankAccount extends _i1.EndpointRef {
  EndpointNubankAccount(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'nubankAccount';

  _i2.Future<List<_i18.NubankAccount>> list() =>
      caller.callServerEndpoint<List<_i18.NubankAccount>>(
        'nubankAccount',
        'list',
        {},
      );

  _i2.Future<_i18.NubankAccount?> findById(int id) =>
      caller.callServerEndpoint<_i18.NubankAccount?>(
        'nubankAccount',
        'findById',
        {'id': id},
      );

  _i2.Future<List<_i19.SyncLog>> syncLogs(int accountId) =>
      caller.callServerEndpoint<List<_i19.SyncLog>>(
        'nubankAccount',
        'syncLogs',
        {'accountId': accountId},
      );
}

/// {@category Endpoint}
class EndpointOfxImport extends _i1.EndpointRef {
  EndpointOfxImport(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'ofxImport';

  _i2.Future<_i15.ImportHistory> importOfx(
    String ofxContent,
    String fileName,
  ) => caller.callServerEndpoint<_i15.ImportHistory>(
    'ofxImport',
    'importOfx',
    {
      'ofxContent': ofxContent,
      'fileName': fileName,
    },
  );
}

/// {@category Endpoint}
class EndpointTransaction extends _i1.EndpointRef {
  EndpointTransaction(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'transaction';

  _i2.Future<List<_i14.FinancialTransaction>> list() =>
      caller.callServerEndpoint<List<_i14.FinancialTransaction>>(
        'transaction',
        'list',
        {},
      );

  _i2.Future<List<_i14.FinancialTransaction>> listByMonth(DateTime month) =>
      caller.callServerEndpoint<List<_i14.FinancialTransaction>>(
        'transaction',
        'listByMonth',
        {'month': month},
      );

  _i2.Future<_i14.FinancialTransaction> create(
    _i14.FinancialTransaction transaction,
  ) => caller.callServerEndpoint<_i14.FinancialTransaction>(
    'transaction',
    'create',
    {'transaction': transaction},
  );

  _i2.Future<_i14.FinancialTransaction> update(
    _i14.FinancialTransaction transaction,
  ) => caller.callServerEndpoint<_i14.FinancialTransaction>(
    'transaction',
    'update',
    {'transaction': transaction},
  );

  _i2.Future<void> delete(int id) => caller.callServerEndpoint<void>(
    'transaction',
    'delete',
    {'id': id},
  );

  /// Applies an edit to a transaction and optionally propagates the
  /// category and/or display name to the CategoryRule plus all sibling
  /// transactions sharing the same merchant name.
  ///
  /// - Category propagates to siblings and the rule only when
  ///   [propagateCategory] is true.
  /// - Display name propagates only when [propagateDisplayName] is true.
  /// - When a flag is false the corresponding field on the rule (and
  ///   siblings) is left unchanged from its current value.
  _i2.Future<_i14.FinancialTransaction> saveWithPropagation(
    int transactionId,
    String? categoryName,
    String? displayName,
    bool propagateDisplayName,
    bool propagateCategory,
  ) => caller.callServerEndpoint<_i14.FinancialTransaction>(
    'transaction',
    'saveWithPropagation',
    {
      'transactionId': transactionId,
      'categoryName': categoryName,
      'displayName': displayName,
      'propagateDisplayName': propagateDisplayName,
      'propagateCategory': propagateCategory,
    },
  );
}

/// Manual tracking of benefit wallets (Caju), which have no OFX export.
///
/// Each wallet stores an anchor: a balance known to be correct at
/// [BenefitWallet.anchorDate]. The current balance is that anchor plus every
/// wallet transaction that occurred strictly after it, so reconciling with
/// the real Caju app is just moving the anchor — history stays untouched.
/// {@category Endpoint}
class EndpointWallet extends _i1.EndpointRef {
  EndpointWallet(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'wallet';

  _i2.Future<List<_i20.WalletSummary>> summaries(DateTime month) =>
      caller.callServerEndpoint<List<_i20.WalletSummary>>(
        'wallet',
        'summaries',
        {'month': month},
      );

  _i2.Future<List<_i14.FinancialTransaction>> monthTransactions(
    DateTime month,
  ) => caller.callServerEndpoint<List<_i14.FinancialTransaction>>(
    'wallet',
    'monthTransactions',
    {'month': month},
  );

  _i2.Future<_i14.FinancialTransaction> spend(
    String walletSlug,
    double amount,
    String merchantName,
    int? categoryId,
    DateTime? occurredAt,
    String? description,
  ) => caller.callServerEndpoint<_i14.FinancialTransaction>(
    'wallet',
    'spend',
    {
      'walletSlug': walletSlug,
      'amount': amount,
      'merchantName': merchantName,
      'categoryId': categoryId,
      'occurredAt': occurredAt,
      'description': description,
    },
  );

  /// Records a top-up. When [amount] is null, falls back to the wallet's
  /// configured [BenefitWallet.monthlyTopupAmount].
  _i2.Future<_i14.FinancialTransaction> topup(
    String walletSlug,
    double? amount,
    DateTime? occurredAt,
    String? description,
  ) => caller.callServerEndpoint<_i14.FinancialTransaction>(
    'wallet',
    'topup',
    {
      'walletSlug': walletSlug,
      'amount': amount,
      'occurredAt': occurredAt,
      'description': description,
    },
  );

  /// Reconciles the wallet with the balance shown in the Caju app.
  ///
  /// Transactions recorded with an occurredAt after [at] (default: now) keep
  /// counting toward the balance; everything before is covered by the anchor.
  _i2.Future<_i21.BenefitWallet> setBalance(
    String walletSlug,
    double balance,
    DateTime? at,
  ) => caller.callServerEndpoint<_i21.BenefitWallet>(
    'wallet',
    'setBalance',
    {
      'walletSlug': walletSlug,
      'balance': balance,
      'at': at,
    },
  );

  /// Sets the default top-up amount used by [topup] when none is given.
  _i2.Future<_i21.BenefitWallet> setMonthlyTopup(
    String walletSlug,
    double? amount,
  ) => caller.callServerEndpoint<_i21.BenefitWallet>(
    'wallet',
    'setMonthlyTopup',
    {
      'walletSlug': walletSlug,
      'amount': amount,
    },
  );

  _i2.Future<void> deleteTransaction(int id) => caller.callServerEndpoint<void>(
    'wallet',
    'deleteTransaction',
    {'id': id},
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i22.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i22.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i23.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    attachment = EndpointAttachment(this);
    bill = EndpointBill(this);
    budget = EndpointBudget(this);
    category = EndpointCategory(this);
    categoryRule = EndpointCategoryRule(this);
    chat = EndpointChat(this);
    dashboard = EndpointDashboard(this);
    importHistory = EndpointImportHistory(this);
    income = EndpointIncome(this);
    monthlyEntry = EndpointMonthlyEntry(this);
    nubankAccount = EndpointNubankAccount(this);
    ofxImport = EndpointOfxImport(this);
    transaction = EndpointTransaction(this);
    wallet = EndpointWallet(this);
    greeting = EndpointGreeting(this);
  }

  late final EndpointAttachment attachment;

  late final EndpointBill bill;

  late final EndpointBudget budget;

  late final EndpointCategory category;

  late final EndpointCategoryRule categoryRule;

  late final EndpointChat chat;

  late final EndpointDashboard dashboard;

  late final EndpointImportHistory importHistory;

  late final EndpointIncome income;

  late final EndpointMonthlyEntry monthlyEntry;

  late final EndpointNubankAccount nubankAccount;

  late final EndpointOfxImport ofxImport;

  late final EndpointTransaction transaction;

  late final EndpointWallet wallet;

  late final EndpointGreeting greeting;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'attachment': attachment,
    'bill': bill,
    'budget': budget,
    'category': category,
    'categoryRule': categoryRule,
    'chat': chat,
    'dashboard': dashboard,
    'importHistory': importHistory,
    'income': income,
    'monthlyEntry': monthlyEntry,
    'nubankAccount': nubankAccount,
    'ofxImport': ofxImport,
    'transaction': transaction,
    'wallet': wallet,
    'greeting': greeting,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
