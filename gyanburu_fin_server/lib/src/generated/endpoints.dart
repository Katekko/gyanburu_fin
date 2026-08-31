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
import '../endpoints/attachment_endpoint.dart' as _i2;
import '../endpoints/bill_endpoint.dart' as _i3;
import '../endpoints/budget_endpoint.dart' as _i4;
import '../endpoints/category_endpoint.dart' as _i5;
import '../endpoints/category_rule_endpoint.dart' as _i6;
import '../endpoints/chat_endpoint.dart' as _i7;
import '../endpoints/dashboard_endpoint.dart' as _i8;
import '../endpoints/import_history_endpoint.dart' as _i9;
import '../endpoints/income_endpoint.dart' as _i10;
import '../endpoints/monthly_entry_endpoint.dart' as _i11;
import '../endpoints/nubank_account_endpoint.dart' as _i12;
import '../endpoints/ofx_import_endpoint.dart' as _i13;
import '../endpoints/transaction_endpoint.dart' as _i14;
import '../endpoints/wallet_endpoint.dart' as _i15;
import '../greetings/greeting_endpoint.dart' as _i16;
import 'package:gyanburu_fin_server/src/generated/attachment_kind.dart' as _i17;
import 'package:gyanburu_fin_server/src/generated/bill.dart' as _i18;
import 'package:gyanburu_fin_server/src/generated/budget_category.dart' as _i19;
import 'package:gyanburu_fin_server/src/generated/category.dart' as _i20;
import 'package:gyanburu_fin_server/src/generated/category_rule.dart' as _i21;
import 'package:gyanburu_fin_server/src/generated/chat_message.dart' as _i22;
import 'package:gyanburu_fin_server/src/generated/pending_action.dart' as _i23;
import 'package:gyanburu_fin_server/src/generated/income_source.dart' as _i24;
import 'package:gyanburu_fin_server/src/generated/monthly_entry.dart' as _i25;
import 'package:gyanburu_fin_server/src/generated/financial_transaction.dart'
    as _i26;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'attachment': _i2.AttachmentEndpoint()
        ..initialize(
          server,
          'attachment',
          null,
        ),
      'bill': _i3.BillEndpoint()
        ..initialize(
          server,
          'bill',
          null,
        ),
      'budget': _i4.BudgetEndpoint()
        ..initialize(
          server,
          'budget',
          null,
        ),
      'category': _i5.CategoryEndpoint()
        ..initialize(
          server,
          'category',
          null,
        ),
      'categoryRule': _i6.CategoryRuleEndpoint()
        ..initialize(
          server,
          'categoryRule',
          null,
        ),
      'chat': _i7.ChatEndpoint()
        ..initialize(
          server,
          'chat',
          null,
        ),
      'dashboard': _i8.DashboardEndpoint()
        ..initialize(
          server,
          'dashboard',
          null,
        ),
      'importHistory': _i9.ImportHistoryEndpoint()
        ..initialize(
          server,
          'importHistory',
          null,
        ),
      'income': _i10.IncomeEndpoint()
        ..initialize(
          server,
          'income',
          null,
        ),
      'monthlyEntry': _i11.MonthlyEntryEndpoint()
        ..initialize(
          server,
          'monthlyEntry',
          null,
        ),
      'nubankAccount': _i12.NubankAccountEndpoint()
        ..initialize(
          server,
          'nubankAccount',
          null,
        ),
      'ofxImport': _i13.OfxImportEndpoint()
        ..initialize(
          server,
          'ofxImport',
          null,
        ),
      'transaction': _i14.TransactionEndpoint()
        ..initialize(
          server,
          'transaction',
          null,
        ),
      'wallet': _i15.WalletEndpoint()
        ..initialize(
          server,
          'wallet',
          null,
        ),
      'greeting': _i16.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['attachment'] = _i1.EndpointConnector(
      name: 'attachment',
      endpoint: endpoints['attachment']!,
      methodConnectors: {
        'requestUpload': _i1.MethodConnector(
          name: 'requestUpload',
          params: {
            'entryId': _i1.ParameterDescription(
              name: 'entryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'kind': _i1.ParameterDescription(
              name: 'kind',
              type: _i1.getType<_i17.AttachmentKind>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'contentLength': _i1.ParameterDescription(
              name: 'contentLength',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['attachment'] as _i2.AttachmentEndpoint)
                  .requestUpload(
                    session,
                    params['entryId'],
                    params['kind'],
                    params['fileName'],
                    params['contentLength'],
                  ),
        ),
        'confirmUpload': _i1.MethodConnector(
          name: 'confirmUpload',
          params: {
            'entryId': _i1.ParameterDescription(
              name: 'entryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'kind': _i1.ParameterDescription(
              name: 'kind',
              type: _i1.getType<_i17.AttachmentKind>(),
              nullable: false,
            ),
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'contentType': _i1.ParameterDescription(
              name: 'contentType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'sizeBytes': _i1.ParameterDescription(
              name: 'sizeBytes',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['attachment'] as _i2.AttachmentEndpoint)
                  .confirmUpload(
                    session,
                    params['entryId'],
                    params['kind'],
                    params['path'],
                    params['fileName'],
                    params['contentType'],
                    params['sizeBytes'],
                  ),
        ),
        'listForEntry': _i1.MethodConnector(
          name: 'listForEntry',
          params: {
            'entryId': _i1.ParameterDescription(
              name: 'entryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['attachment'] as _i2.AttachmentEndpoint)
                  .listForEntry(
                    session,
                    params['entryId'],
                  ),
        ),
        'entryIdsWithAttachments': _i1.MethodConnector(
          name: 'entryIdsWithAttachments',
          params: {
            'entryIds': _i1.ParameterDescription(
              name: 'entryIds',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['attachment'] as _i2.AttachmentEndpoint)
                  .entryIdsWithAttachments(
                    session,
                    params['entryIds'],
                  ),
        ),
        'getData': _i1.MethodConnector(
          name: 'getData',
          params: {
            'attachmentId': _i1.ParameterDescription(
              name: 'attachmentId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['attachment'] as _i2.AttachmentEndpoint).getData(
                    session,
                    params['attachmentId'],
                  ),
        ),
        'deleteAttachment': _i1.MethodConnector(
          name: 'deleteAttachment',
          params: {
            'attachmentId': _i1.ParameterDescription(
              name: 'attachmentId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['attachment'] as _i2.AttachmentEndpoint)
                  .deleteAttachment(
                    session,
                    params['attachmentId'],
                  ),
        ),
      },
    );
    connectors['bill'] = _i1.EndpointConnector(
      name: 'bill',
      endpoint: endpoints['bill']!,
      methodConnectors: {
        'list': _i1.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bill'] as _i3.BillEndpoint).list(session),
        ),
        'listUpcoming': _i1.MethodConnector(
          name: 'listUpcoming',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['bill'] as _i3.BillEndpoint).listUpcoming(session),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'bill': _i1.ParameterDescription(
              name: 'bill',
              type: _i1.getType<_i18.Bill>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bill'] as _i3.BillEndpoint).create(
                session,
                params['bill'],
              ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'bill': _i1.ParameterDescription(
              name: 'bill',
              type: _i1.getType<_i18.Bill>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bill'] as _i3.BillEndpoint).update(
                session,
                params['bill'],
              ),
        ),
        'markAsPaid': _i1.MethodConnector(
          name: 'markAsPaid',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bill'] as _i3.BillEndpoint).markAsPaid(
                session,
                params['id'],
              ),
        ),
        'delete': _i1.MethodConnector(
          name: 'delete',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bill'] as _i3.BillEndpoint).delete(
                session,
                params['id'],
              ),
        ),
      },
    );
    connectors['budget'] = _i1.EndpointConnector(
      name: 'budget',
      endpoint: endpoints['budget']!,
      methodConnectors: {
        'listByMonth': _i1.MethodConnector(
          name: 'listByMonth',
          params: {
            'month': _i1.ParameterDescription(
              name: 'month',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['budget'] as _i4.BudgetEndpoint).listByMonth(
                    session,
                    params['month'],
                  ),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<_i19.BudgetCategory>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['budget'] as _i4.BudgetEndpoint).create(
                session,
                params['category'],
              ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<_i19.BudgetCategory>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['budget'] as _i4.BudgetEndpoint).update(
                session,
                params['category'],
              ),
        ),
        'delete': _i1.MethodConnector(
          name: 'delete',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['budget'] as _i4.BudgetEndpoint).delete(
                session,
                params['id'],
              ),
        ),
      },
    );
    connectors['category'] = _i1.EndpointConnector(
      name: 'category',
      endpoint: endpoints['category']!,
      methodConnectors: {
        'list': _i1.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['category'] as _i5.CategoryEndpoint).list(session),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<_i20.Category>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['category'] as _i5.CategoryEndpoint).create(
                session,
                params['category'],
              ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<_i20.Category>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['category'] as _i5.CategoryEndpoint).update(
                session,
                params['category'],
              ),
        ),
        'delete': _i1.MethodConnector(
          name: 'delete',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['category'] as _i5.CategoryEndpoint).delete(
                session,
                params['id'],
              ),
        ),
      },
    );
    connectors['categoryRule'] = _i1.EndpointConnector(
      name: 'categoryRule',
      endpoint: endpoints['categoryRule']!,
      methodConnectors: {
        'list': _i1.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['categoryRule'] as _i6.CategoryRuleEndpoint)
                  .list(session),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'rule': _i1.ParameterDescription(
              name: 'rule',
              type: _i1.getType<_i21.CategoryRule>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['categoryRule'] as _i6.CategoryRuleEndpoint)
                  .create(
                    session,
                    params['rule'],
                  ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'rule': _i1.ParameterDescription(
              name: 'rule',
              type: _i1.getType<_i21.CategoryRule>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['categoryRule'] as _i6.CategoryRuleEndpoint)
                  .update(
                    session,
                    params['rule'],
                  ),
        ),
        'delete': _i1.MethodConnector(
          name: 'delete',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['categoryRule'] as _i6.CategoryRuleEndpoint)
                  .delete(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['chat'] = _i1.EndpointConnector(
      name: 'chat',
      endpoint: endpoints['chat']!,
      methodConnectors: {
        'sendMessage': _i1.MethodConnector(
          name: 'sendMessage',
          params: {
            'history': _i1.ParameterDescription(
              name: 'history',
              type: _i1.getType<List<_i22.ChatMessage>>(),
              nullable: false,
            ),
            'userMessage': _i1.ParameterDescription(
              name: 'userMessage',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['chat'] as _i7.ChatEndpoint).sendMessage(
                session,
                params['history'],
                params['userMessage'],
              ),
        ),
        'executeActions': _i1.MethodConnector(
          name: 'executeActions',
          params: {
            'actions': _i1.ParameterDescription(
              name: 'actions',
              type: _i1.getType<List<_i23.PendingAction>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['chat'] as _i7.ChatEndpoint).executeActions(
                session,
                params['actions'],
              ),
        ),
      },
    );
    connectors['dashboard'] = _i1.EndpointConnector(
      name: 'dashboard',
      endpoint: endpoints['dashboard']!,
      methodConnectors: {
        'spendingByCategory': _i1.MethodConnector(
          name: 'spendingByCategory',
          params: {
            'month': _i1.ParameterDescription(
              name: 'month',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['dashboard'] as _i8.DashboardEndpoint)
                  .spendingByCategory(
                    session,
                    params['month'],
                  ),
        ),
        'recentTransactions': _i1.MethodConnector(
          name: 'recentTransactions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['dashboard'] as _i8.DashboardEndpoint)
                  .recentTransactions(session),
        ),
        'netBalance': _i1.MethodConnector(
          name: 'netBalance',
          params: {
            'month': _i1.ParameterDescription(
              name: 'month',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['dashboard'] as _i8.DashboardEndpoint).netBalance(
                    session,
                    params['month'],
                  ),
        ),
      },
    );
    connectors['importHistory'] = _i1.EndpointConnector(
      name: 'importHistory',
      endpoint: endpoints['importHistory']!,
      methodConnectors: {
        'list': _i1.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['importHistory'] as _i9.ImportHistoryEndpoint)
                      .list(session),
        ),
      },
    );
    connectors['income'] = _i1.EndpointConnector(
      name: 'income',
      endpoint: endpoints['income']!,
      methodConnectors: {
        'listByMonth': _i1.MethodConnector(
          name: 'listByMonth',
          params: {
            'month': _i1.ParameterDescription(
              name: 'month',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['income'] as _i10.IncomeEndpoint).listByMonth(
                    session,
                    params['month'],
                  ),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'source': _i1.ParameterDescription(
              name: 'source',
              type: _i1.getType<_i24.IncomeSource>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['income'] as _i10.IncomeEndpoint).create(
                session,
                params['source'],
              ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'source': _i1.ParameterDescription(
              name: 'source',
              type: _i1.getType<_i24.IncomeSource>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['income'] as _i10.IncomeEndpoint).update(
                session,
                params['source'],
              ),
        ),
        'delete': _i1.MethodConnector(
          name: 'delete',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['income'] as _i10.IncomeEndpoint).delete(
                session,
                params['id'],
              ),
        ),
      },
    );
    connectors['monthlyEntry'] = _i1.EndpointConnector(
      name: 'monthlyEntry',
      endpoint: endpoints['monthlyEntry']!,
      methodConnectors: {
        'listByMonth': _i1.MethodConnector(
          name: 'listByMonth',
          params: {
            'month': _i1.ParameterDescription(
              name: 'month',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['monthlyEntry'] as _i11.MonthlyEntryEndpoint)
                      .listByMonth(
                        session,
                        params['month'],
                      ),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'entry': _i1.ParameterDescription(
              name: 'entry',
              type: _i1.getType<_i25.MonthlyEntry>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['monthlyEntry'] as _i11.MonthlyEntryEndpoint)
                      .create(
                        session,
                        params['entry'],
                      ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'entry': _i1.ParameterDescription(
              name: 'entry',
              type: _i1.getType<_i25.MonthlyEntry>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['monthlyEntry'] as _i11.MonthlyEntryEndpoint)
                      .update(
                        session,
                        params['entry'],
                      ),
        ),
        'delete': _i1.MethodConnector(
          name: 'delete',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['monthlyEntry'] as _i11.MonthlyEntryEndpoint)
                      .delete(
                        session,
                        params['id'],
                      ),
        ),
      },
    );
    connectors['nubankAccount'] = _i1.EndpointConnector(
      name: 'nubankAccount',
      endpoint: endpoints['nubankAccount']!,
      methodConnectors: {
        'list': _i1.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['nubankAccount'] as _i12.NubankAccountEndpoint)
                      .list(session),
        ),
        'findById': _i1.MethodConnector(
          name: 'findById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['nubankAccount'] as _i12.NubankAccountEndpoint)
                      .findById(
                        session,
                        params['id'],
                      ),
        ),
        'syncLogs': _i1.MethodConnector(
          name: 'syncLogs',
          params: {
            'accountId': _i1.ParameterDescription(
              name: 'accountId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['nubankAccount'] as _i12.NubankAccountEndpoint)
                      .syncLogs(
                        session,
                        params['accountId'],
                      ),
        ),
      },
    );
    connectors['ofxImport'] = _i1.EndpointConnector(
      name: 'ofxImport',
      endpoint: endpoints['ofxImport']!,
      methodConnectors: {
        'importOfx': _i1.MethodConnector(
          name: 'importOfx',
          params: {
            'ofxContent': _i1.ParameterDescription(
              name: 'ofxContent',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['ofxImport'] as _i13.OfxImportEndpoint).importOfx(
                    session,
                    params['ofxContent'],
                    params['fileName'],
                  ),
        ),
      },
    );
    connectors['transaction'] = _i1.EndpointConnector(
      name: 'transaction',
      endpoint: endpoints['transaction']!,
      methodConnectors: {
        'list': _i1.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['transaction'] as _i14.TransactionEndpoint)
                  .list(session),
        ),
        'listByMonth': _i1.MethodConnector(
          name: 'listByMonth',
          params: {
            'month': _i1.ParameterDescription(
              name: 'month',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['transaction'] as _i14.TransactionEndpoint)
                  .listByMonth(
                    session,
                    params['month'],
                  ),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'transaction': _i1.ParameterDescription(
              name: 'transaction',
              type: _i1.getType<_i26.FinancialTransaction>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _i14.TransactionEndpoint).create(
                    session,
                    params['transaction'],
                  ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'transaction': _i1.ParameterDescription(
              name: 'transaction',
              type: _i1.getType<_i26.FinancialTransaction>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _i14.TransactionEndpoint).update(
                    session,
                    params['transaction'],
                  ),
        ),
        'delete': _i1.MethodConnector(
          name: 'delete',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _i14.TransactionEndpoint).delete(
                    session,
                    params['id'],
                  ),
        ),
        'saveWithPropagation': _i1.MethodConnector(
          name: 'saveWithPropagation',
          params: {
            'transactionId': _i1.ParameterDescription(
              name: 'transactionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'categoryName': _i1.ParameterDescription(
              name: 'categoryName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'displayName': _i1.ParameterDescription(
              name: 'displayName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'propagateDisplayName': _i1.ParameterDescription(
              name: 'propagateDisplayName',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'propagateCategory': _i1.ParameterDescription(
              name: 'propagateCategory',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['transaction'] as _i14.TransactionEndpoint)
                  .saveWithPropagation(
                    session,
                    params['transactionId'],
                    params['categoryName'],
                    params['displayName'],
                    params['propagateDisplayName'],
                    params['propagateCategory'],
                  ),
        ),
      },
    );
    connectors['wallet'] = _i1.EndpointConnector(
      name: 'wallet',
      endpoint: endpoints['wallet']!,
      methodConnectors: {
        'summaries': _i1.MethodConnector(
          name: 'summaries',
          params: {
            'month': _i1.ParameterDescription(
              name: 'month',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['wallet'] as _i15.WalletEndpoint).summaries(
                session,
                params['month'],
              ),
        ),
        'monthTransactions': _i1.MethodConnector(
          name: 'monthTransactions',
          params: {
            'month': _i1.ParameterDescription(
              name: 'month',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['wallet'] as _i15.WalletEndpoint)
                  .monthTransactions(
                    session,
                    params['month'],
                  ),
        ),
        'spend': _i1.MethodConnector(
          name: 'spend',
          params: {
            'walletSlug': _i1.ParameterDescription(
              name: 'walletSlug',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'merchantName': _i1.ParameterDescription(
              name: 'merchantName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'categoryId': _i1.ParameterDescription(
              name: 'categoryId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'occurredAt': _i1.ParameterDescription(
              name: 'occurredAt',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['wallet'] as _i15.WalletEndpoint).spend(
                session,
                params['walletSlug'],
                params['amount'],
                params['merchantName'],
                params['categoryId'],
                params['occurredAt'],
                params['description'],
              ),
        ),
        'topup': _i1.MethodConnector(
          name: 'topup',
          params: {
            'walletSlug': _i1.ParameterDescription(
              name: 'walletSlug',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'occurredAt': _i1.ParameterDescription(
              name: 'occurredAt',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['wallet'] as _i15.WalletEndpoint).topup(
                session,
                params['walletSlug'],
                params['amount'],
                params['occurredAt'],
                params['description'],
              ),
        ),
        'setBalance': _i1.MethodConnector(
          name: 'setBalance',
          params: {
            'walletSlug': _i1.ParameterDescription(
              name: 'walletSlug',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'balance': _i1.ParameterDescription(
              name: 'balance',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'at': _i1.ParameterDescription(
              name: 'at',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['wallet'] as _i15.WalletEndpoint).setBalance(
                    session,
                    params['walletSlug'],
                    params['balance'],
                    params['at'],
                  ),
        ),
        'setMonthlyTopup': _i1.MethodConnector(
          name: 'setMonthlyTopup',
          params: {
            'walletSlug': _i1.ParameterDescription(
              name: 'walletSlug',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['wallet'] as _i15.WalletEndpoint).setMonthlyTopup(
                    session,
                    params['walletSlug'],
                    params['amount'],
                  ),
        ),
        'deleteTransaction': _i1.MethodConnector(
          name: 'deleteTransaction',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['wallet'] as _i15.WalletEndpoint)
                  .deleteTransaction(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i16.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
  }
}
