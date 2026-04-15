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
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'account_type.dart' as _i5;
import 'bill.dart' as _i6;
import 'bill_status.dart' as _i7;
import 'budget_category.dart' as _i8;
import 'category.dart' as _i9;
import 'category_rule.dart' as _i10;
import 'entry_type.dart' as _i11;
import 'financial_transaction.dart' as _i12;
import 'greetings/greeting.dart' as _i13;
import 'import_history.dart' as _i14;
import 'income_source.dart' as _i15;
import 'income_type.dart' as _i16;
import 'monthly_entry.dart' as _i17;
import 'nubank_account.dart' as _i18;
import 'sync_log.dart' as _i19;
import 'sync_status.dart' as _i20;
import 'package:gyanburu_fin_server/src/generated/bill.dart' as _i21;
import 'package:gyanburu_fin_server/src/generated/budget_category.dart' as _i22;
import 'package:gyanburu_fin_server/src/generated/category.dart' as _i23;
import 'package:gyanburu_fin_server/src/generated/category_rule.dart' as _i24;
import 'package:gyanburu_fin_server/src/generated/financial_transaction.dart'
    as _i25;
import 'package:gyanburu_fin_server/src/generated/import_history.dart' as _i26;
import 'package:gyanburu_fin_server/src/generated/income_source.dart' as _i27;
import 'package:gyanburu_fin_server/src/generated/monthly_entry.dart' as _i28;
import 'package:gyanburu_fin_server/src/generated/nubank_account.dart' as _i29;
import 'package:gyanburu_fin_server/src/generated/sync_log.dart' as _i30;
export 'account_type.dart';
export 'bill.dart';
export 'bill_status.dart';
export 'budget_category.dart';
export 'category.dart';
export 'category_rule.dart';
export 'entry_type.dart';
export 'financial_transaction.dart';
export 'greetings/greeting.dart';
export 'import_history.dart';
export 'income_source.dart';
export 'income_type.dart';
export 'monthly_entry.dart';
export 'nubank_account.dart';
export 'sync_log.dart';
export 'sync_status.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'bill',
      dartName: 'Bill',
      schema: 'public',
      module: 'gyanburu_fin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'bill_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'merchantName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'amount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'dueAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:BillStatus',
        ),
        _i2.ColumnDefinition(
          name: 'recurrent',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'bill_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'budget_category',
      dartName: 'BudgetCategory',
      schema: 'public',
      module: 'gyanburu_fin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'budget_category_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'icon',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'limitAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'month',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'budget_category_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'category',
      dartName: 'Category',
      schema: 'public',
      module: 'gyanburu_fin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'category_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'icon',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'color',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'category_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'category_rule',
      dartName: 'CategoryRule',
      schema: 'public',
      module: 'gyanburu_fin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'category_rule_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'merchantPattern',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'categoryId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'displayName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'category_rule_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'financial_transaction',
      dartName: 'FinancialTransaction',
      schema: 'public',
      module: 'gyanburu_fin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'financial_transaction_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'nubankAccountId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'merchantName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'category',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'amount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'currency',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'occurredAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'externalId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'installmentCurrent',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'installmentTotal',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'displayName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'billingMonth',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'source',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'kind',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'financial_transaction_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'import_history',
      dartName: 'ImportHistory',
      schema: 'public',
      module: 'gyanburu_fin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'import_history_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'importedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'fileName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'statementStart',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'statementEnd',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'totalTransactions',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'newTransactions',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'skippedDuplicates',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'skippedCredits',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'import_history_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'income_source',
      dartName: 'IncomeSource',
      schema: 'public',
      module: 'gyanburu_fin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'income_source_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'type',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:IncomeType',
        ),
        _i2.ColumnDefinition(
          name: 'amount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'month',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'income_source_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'monthly_entry',
      dartName: 'MonthlyEntry',
      schema: 'public',
      module: 'gyanburu_fin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'monthly_entry_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'categoryId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'type',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:EntryType',
        ),
        _i2.ColumnDefinition(
          name: 'amount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'month',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'recurrent',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'variable',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'confirmed',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'dueDate',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'paid',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'paidAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'paidAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'paymentMethod',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'paymentNote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'monthly_entry_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'nubank_account',
      dartName: 'NubankAccount',
      schema: 'public',
      module: 'gyanburu_fin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'nubank_account_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'accountType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AccountType',
        ),
        _i2.ColumnDefinition(
          name: 'lastSyncAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'syncStatus',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SyncStatus',
        ),
        _i2.ColumnDefinition(
          name: 'consentExpiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'nubank_account_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'sync_log',
      dartName: 'SyncLog',
      schema: 'public',
      module: 'gyanburu_fin',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'sync_log_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'nubankAccountId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'syncedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SyncStatus',
        ),
        _i2.ColumnDefinition(
          name: 'errorMessage',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'sync_log_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

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

    if (t == _i5.AccountType) {
      return _i5.AccountType.fromJson(data) as T;
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
    if (t == _i11.EntryType) {
      return _i11.EntryType.fromJson(data) as T;
    }
    if (t == _i12.FinancialTransaction) {
      return _i12.FinancialTransaction.fromJson(data) as T;
    }
    if (t == _i13.Greeting) {
      return _i13.Greeting.fromJson(data) as T;
    }
    if (t == _i14.ImportHistory) {
      return _i14.ImportHistory.fromJson(data) as T;
    }
    if (t == _i15.IncomeSource) {
      return _i15.IncomeSource.fromJson(data) as T;
    }
    if (t == _i16.IncomeType) {
      return _i16.IncomeType.fromJson(data) as T;
    }
    if (t == _i17.MonthlyEntry) {
      return _i17.MonthlyEntry.fromJson(data) as T;
    }
    if (t == _i18.NubankAccount) {
      return _i18.NubankAccount.fromJson(data) as T;
    }
    if (t == _i19.SyncLog) {
      return _i19.SyncLog.fromJson(data) as T;
    }
    if (t == _i20.SyncStatus) {
      return _i20.SyncStatus.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.AccountType?>()) {
      return (data != null ? _i5.AccountType.fromJson(data) : null) as T;
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
    if (t == _i1.getType<_i11.EntryType?>()) {
      return (data != null ? _i11.EntryType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.FinancialTransaction?>()) {
      return (data != null ? _i12.FinancialTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.Greeting?>()) {
      return (data != null ? _i13.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.ImportHistory?>()) {
      return (data != null ? _i14.ImportHistory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.IncomeSource?>()) {
      return (data != null ? _i15.IncomeSource.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.IncomeType?>()) {
      return (data != null ? _i16.IncomeType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.MonthlyEntry?>()) {
      return (data != null ? _i17.MonthlyEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.NubankAccount?>()) {
      return (data != null ? _i18.NubankAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.SyncLog?>()) {
      return (data != null ? _i19.SyncLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.SyncStatus?>()) {
      return (data != null ? _i20.SyncStatus.fromJson(data) : null) as T;
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
    if (t == Map<String, double>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<double>(v)),
          )
          as T;
    }
    if (t == List<_i25.FinancialTransaction>) {
      return (data as List)
              .map((e) => deserialize<_i25.FinancialTransaction>(e))
              .toList()
          as T;
    }
    if (t == List<_i26.ImportHistory>) {
      return (data as List)
              .map((e) => deserialize<_i26.ImportHistory>(e))
              .toList()
          as T;
    }
    if (t == List<_i27.IncomeSource>) {
      return (data as List)
              .map((e) => deserialize<_i27.IncomeSource>(e))
              .toList()
          as T;
    }
    if (t == List<_i28.MonthlyEntry>) {
      return (data as List)
              .map((e) => deserialize<_i28.MonthlyEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i29.NubankAccount>) {
      return (data as List)
              .map((e) => deserialize<_i29.NubankAccount>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.SyncLog>) {
      return (data as List).map((e) => deserialize<_i30.SyncLog>(e)).toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.AccountType => 'AccountType',
      _i6.Bill => 'Bill',
      _i7.BillStatus => 'BillStatus',
      _i8.BudgetCategory => 'BudgetCategory',
      _i9.Category => 'Category',
      _i10.CategoryRule => 'CategoryRule',
      _i11.EntryType => 'EntryType',
      _i12.FinancialTransaction => 'FinancialTransaction',
      _i13.Greeting => 'Greeting',
      _i14.ImportHistory => 'ImportHistory',
      _i15.IncomeSource => 'IncomeSource',
      _i16.IncomeType => 'IncomeType',
      _i17.MonthlyEntry => 'MonthlyEntry',
      _i18.NubankAccount => 'NubankAccount',
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
      case _i5.AccountType():
        return 'AccountType';
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
      case _i11.EntryType():
        return 'EntryType';
      case _i12.FinancialTransaction():
        return 'FinancialTransaction';
      case _i13.Greeting():
        return 'Greeting';
      case _i14.ImportHistory():
        return 'ImportHistory';
      case _i15.IncomeSource():
        return 'IncomeSource';
      case _i16.IncomeType():
        return 'IncomeType';
      case _i17.MonthlyEntry():
        return 'MonthlyEntry';
      case _i18.NubankAccount():
        return 'NubankAccount';
      case _i19.SyncLog():
        return 'SyncLog';
      case _i20.SyncStatus():
        return 'SyncStatus';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
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
      return deserialize<_i5.AccountType>(data['data']);
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
    if (dataClassName == 'EntryType') {
      return deserialize<_i11.EntryType>(data['data']);
    }
    if (dataClassName == 'FinancialTransaction') {
      return deserialize<_i12.FinancialTransaction>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i13.Greeting>(data['data']);
    }
    if (dataClassName == 'ImportHistory') {
      return deserialize<_i14.ImportHistory>(data['data']);
    }
    if (dataClassName == 'IncomeSource') {
      return deserialize<_i15.IncomeSource>(data['data']);
    }
    if (dataClassName == 'IncomeType') {
      return deserialize<_i16.IncomeType>(data['data']);
    }
    if (dataClassName == 'MonthlyEntry') {
      return deserialize<_i17.MonthlyEntry>(data['data']);
    }
    if (dataClassName == 'NubankAccount') {
      return deserialize<_i18.NubankAccount>(data['data']);
    }
    if (dataClassName == 'SyncLog') {
      return deserialize<_i19.SyncLog>(data['data']);
    }
    if (dataClassName == 'SyncStatus') {
      return deserialize<_i20.SyncStatus>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i6.Bill:
        return _i6.Bill.t;
      case _i8.BudgetCategory:
        return _i8.BudgetCategory.t;
      case _i9.Category:
        return _i9.Category.t;
      case _i10.CategoryRule:
        return _i10.CategoryRule.t;
      case _i12.FinancialTransaction:
        return _i12.FinancialTransaction.t;
      case _i14.ImportHistory:
        return _i14.ImportHistory.t;
      case _i15.IncomeSource:
        return _i15.IncomeSource.t;
      case _i17.MonthlyEntry:
        return _i17.MonthlyEntry.t;
      case _i18.NubankAccount:
        return _i18.NubankAccount.t;
      case _i19.SyncLog:
        return _i19.SyncLog.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'gyanburu_fin';

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
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
