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
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../endpoints/bill_endpoint.dart' as _i4;
import '../endpoints/budget_endpoint.dart' as _i5;
import '../endpoints/dashboard_endpoint.dart' as _i6;
import '../endpoints/income_endpoint.dart' as _i7;
import '../endpoints/nubank_account_endpoint.dart' as _i8;
import '../endpoints/transaction_endpoint.dart' as _i9;
import '../greetings/greeting_endpoint.dart' as _i10;
import 'package:gyanburu_fin_server/src/generated/bill.dart' as _i11;
import 'package:gyanburu_fin_server/src/generated/budget_category.dart' as _i12;
import 'package:gyanburu_fin_server/src/generated/income_source.dart' as _i13;
import 'package:gyanburu_fin_server/src/generated/financial_transaction.dart'
    as _i14;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i15;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i16;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'bill': _i4.BillEndpoint()
        ..initialize(
          server,
          'bill',
          null,
        ),
      'budget': _i5.BudgetEndpoint()
        ..initialize(
          server,
          'budget',
          null,
        ),
      'dashboard': _i6.DashboardEndpoint()
        ..initialize(
          server,
          'dashboard',
          null,
        ),
      'income': _i7.IncomeEndpoint()
        ..initialize(
          server,
          'income',
          null,
        ),
      'nubankAccount': _i8.NubankAccountEndpoint()
        ..initialize(
          server,
          'nubankAccount',
          null,
        ),
      'transaction': _i9.TransactionEndpoint()
        ..initialize(
          server,
          'transaction',
          null,
        ),
      'greeting': _i10.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
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
              ) async => (endpoints['bill'] as _i4.BillEndpoint).list(session),
        ),
        'listUpcoming': _i1.MethodConnector(
          name: 'listUpcoming',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['bill'] as _i4.BillEndpoint).listUpcoming(session),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'bill': _i1.ParameterDescription(
              name: 'bill',
              type: _i1.getType<_i11.Bill>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bill'] as _i4.BillEndpoint).create(
                session,
                params['bill'],
              ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'bill': _i1.ParameterDescription(
              name: 'bill',
              type: _i1.getType<_i11.Bill>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bill'] as _i4.BillEndpoint).update(
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
              ) async => (endpoints['bill'] as _i4.BillEndpoint).markAsPaid(
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
              ) async => (endpoints['bill'] as _i4.BillEndpoint).delete(
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
                  (endpoints['budget'] as _i5.BudgetEndpoint).listByMonth(
                    session,
                    params['month'],
                  ),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<_i12.BudgetCategory>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['budget'] as _i5.BudgetEndpoint).create(
                session,
                params['category'],
              ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<_i12.BudgetCategory>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['budget'] as _i5.BudgetEndpoint).update(
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
              ) async => (endpoints['budget'] as _i5.BudgetEndpoint).delete(
                session,
                params['id'],
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
              ) async => (endpoints['dashboard'] as _i6.DashboardEndpoint)
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
              ) async => (endpoints['dashboard'] as _i6.DashboardEndpoint)
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
                  (endpoints['dashboard'] as _i6.DashboardEndpoint).netBalance(
                    session,
                    params['month'],
                  ),
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
                  (endpoints['income'] as _i7.IncomeEndpoint).listByMonth(
                    session,
                    params['month'],
                  ),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'source': _i1.ParameterDescription(
              name: 'source',
              type: _i1.getType<_i13.IncomeSource>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['income'] as _i7.IncomeEndpoint).create(
                session,
                params['source'],
              ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'source': _i1.ParameterDescription(
              name: 'source',
              type: _i1.getType<_i13.IncomeSource>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['income'] as _i7.IncomeEndpoint).update(
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
              ) async => (endpoints['income'] as _i7.IncomeEndpoint).delete(
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
                  (endpoints['nubankAccount'] as _i8.NubankAccountEndpoint)
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
                  (endpoints['nubankAccount'] as _i8.NubankAccountEndpoint)
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
                  (endpoints['nubankAccount'] as _i8.NubankAccountEndpoint)
                      .syncLogs(
                        session,
                        params['accountId'],
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
              ) async => (endpoints['transaction'] as _i9.TransactionEndpoint)
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
              ) async => (endpoints['transaction'] as _i9.TransactionEndpoint)
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
              type: _i1.getType<_i14.FinancialTransaction>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _i9.TransactionEndpoint).create(
                    session,
                    params['transaction'],
                  ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'transaction': _i1.ParameterDescription(
              name: 'transaction',
              type: _i1.getType<_i14.FinancialTransaction>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['transaction'] as _i9.TransactionEndpoint).update(
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
                  (endpoints['transaction'] as _i9.TransactionEndpoint).delete(
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
              ) async => (endpoints['greeting'] as _i10.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i15.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i16.Endpoints()
      ..initializeEndpoints(server);
  }
}
