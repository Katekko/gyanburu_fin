import 'dart:io';

import 'package:args/args.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:gyanburu_fin_cli/src/session.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('server', help: 'URL do servidor (default: produção)')
    ..addFlag('help', abbr: 'h', negatable: false);

  parser.addCommand('set-token');
  parser.addCommand('whoami');
  parser.addCommand('import-ofx');
  parser.addCommand('entries');
  parser.addCommand('transactions');
  parser.addCommand('uncategorized');
  parser.addCommand('imports');
  parser.addCommand('categories');
  parser.addCommand('entry-delete');

  parser.addCommand('entry-new')
    ..addOption('month', help: 'Mês do lançamento (YYYY-MM)', mandatory: true)
    ..addOption('name', mandatory: true)
    ..addOption('amount', mandatory: true)
    ..addOption('type', allowed: ['income', 'expense'], defaultsTo: 'expense')
    ..addOption('category-id', mandatory: true)
    ..addOption('due', help: 'Data de vencimento (YYYY-MM-DD)')
    ..addFlag('recurrent', defaultsTo: true)
    ..addFlag('variable', defaultsTo: false)
    ..addFlag('confirmed', defaultsTo: true)
    ..addFlag('paid', defaultsTo: false);

  parser.addCommand('caju');
  parser.addCommand('caju-delete');

  const walletSlugs = ['comida', 'home-office', 'home'];

  parser.addCommand('caju-spend')
    ..addOption('wallet', allowed: walletSlugs, mandatory: true)
    ..addOption('amount', mandatory: true)
    ..addOption('name', help: 'Estabelecimento', mandatory: true)
    ..addOption('category-id')
    ..addOption('date', help: 'Data do gasto (YYYY-MM-DD, default: hoje)')
    ..addOption('desc');

  parser.addCommand('caju-topup')
    ..addOption('wallet', allowed: walletSlugs, mandatory: true)
    ..addOption('amount', help: 'Default: recarga mensal configurada')
    ..addOption('date', help: 'Data da recarga (YYYY-MM-DD, default: hoje)')
    ..addOption('desc');

  parser.addCommand('caju-set-balance')
    ..addOption('wallet', allowed: walletSlugs, mandatory: true)
    ..addOption('amount', mandatory: true)
    ..addOption('date',
        help: 'Dia do saldo informado (YYYY-MM-DD, âncora no fim do dia; '
            'default: agora)');

  parser.addCommand('caju-set-topup')
    ..addOption('wallet', allowed: walletSlugs, mandatory: true)
    ..addOption('amount', help: 'Valor da recarga mensal (vazio p/ limpar)');

  parser.addCommand('entry-set')
    ..addOption('month', help: 'Mês do lançamento (YYYY-MM)', mandatory: true)
    ..addOption('id', help: 'Id do lançamento', mandatory: true)
    ..addOption('amount')
    ..addOption('name')
    ..addOption('due', help: 'Data de vencimento (YYYY-MM-DD)')
    ..addOption('paid-amount')
    ..addOption('payment-note')
    ..addFlag('paid', defaultsTo: null)
    ..addFlag('variable', defaultsTo: null)
    ..addFlag('confirmed', defaultsTo: null);

  final ArgResults opts;
  try {
    opts = parser.parse(args);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    _usage(parser);
    exit(64);
  }

  final command = opts.command;
  if (opts['help'] as bool || command == null) {
    _usage(parser);
    exit(command == null ? 64 : 0);
  }

  if (command.name == 'set-token') {
    _setToken();
    exit(0);
  }

  final client = buildClient(serverUrl: opts['server'] as String?);

  try {
    _requireToken();
    switch (command.name) {
      case 'whoami':
        await _whoami(client);
      case 'import-ofx':
        await _importOfx(client, command.rest);
      case 'entries':
        await _entries(client, _month(command.rest));
      case 'entry-set':
        await _entrySet(client, command);
      case 'entry-new':
        await _entryNew(client, command);
      case 'entry-delete':
        await _entryDelete(client, command.rest);
      case 'categories':
        await _categories(client);
      case 'transactions':
        await _transactions(client, _month(command.rest),
            onlyUncategorized: false);
      case 'uncategorized':
        await _transactions(
          client,
          command.rest.isEmpty ? null : _month(command.rest),
          onlyUncategorized: true,
        );
      case 'imports':
        await _imports(client);
      case 'caju':
        await _caju(client, command.rest);
      case 'caju-spend':
        await _cajuSpend(client, command);
      case 'caju-topup':
        await _cajuTopup(client, command);
      case 'caju-set-balance':
        await _cajuSetBalance(client, command);
      case 'caju-set-topup':
        await _cajuSetTopup(client, command);
      case 'caju-delete':
        await _cajuDelete(client, command.rest);
    }
  } on StateError catch (e) {
    stderr.writeln(e.message);
    exit(1);
  } catch (e) {
    stderr.writeln('Erro: $e');
    exit(1);
  } finally {
    client.close();
  }
}

void _usage(ArgParser parser) {
  stdout.writeln('''
gyanburu — CLI do Gyanburu Fin

Uso: gyanburu [--server URL] <comando>

Comandos:
  set-token                  Salva o token de acesso localmente
  whoami                     Testa o token contra o servidor
  import-ofx <arquivo...>    Importa um ou mais OFX (dedup + regras aplicadas)
  entries <YYYY-MM>          Lista os lançamentos do mês
  entry-set --month --id     Altera um lançamento (ver flags abaixo)
  entry-new --month --name   Cria um lançamento (--amount --category-id)
  entry-delete <id>          Remove um lançamento
  categories                 Lista as categorias
  transactions <YYYY-MM>     Lista as transações do mês
  uncategorized [YYYY-MM]    Transações sem categoria
  imports                    Histórico de importações
  caju [YYYY-MM]             Saldos e lançamentos das carteiras Caju
  caju-spend                 Gasto no Caju (--wallet --amount --name)
  caju-topup                 Recarga no Caju (--wallet, --amount opcional)
  caju-set-balance           Reconcilia o saldo com o app da Caju
  caju-set-topup             Configura a recarga mensal padrão da carteira
  caju-delete <id>           Remove um lançamento do Caju

Carteiras Caju (--wallet): comida (Refeição+Alimentação) | home-office

Flags de entry-set:
  --amount --name --due --paid/--no-paid --variable/--no-variable
  --confirmed/--no-confirmed --paid-amount --payment-note

Opções globais:
${parser.usage}''');
}

void _requireToken() {
  if (readToken() == null) {
    throw StateError(
      'Token não configurado. Rode: gyanburu set-token\n'
      '(ou exporte GYANBURU_TOKEN no ambiente)',
    );
  }
}

void _setToken() {
  var token = promptHidden('Cole o token (apiToken do passwords.yaml)').trim();
  if (token.isEmpty) {
    stderr.writeln('Token vazio, nada foi salvo.');
    exit(1);
  }

  // The prompt doesn't echo, so a double paste is invisible. It produces a
  // value that is exactly its own first half repeated — catch that here
  // rather than letting it fail later as an opaque 401.
  final half = token.length ~/ 2;
  if (token.length.isEven &&
      token.substring(0, half) == token.substring(half)) {
    stdout.writeln('O token veio duplicado (colado duas vezes). '
        'Usando apenas a primeira metade.');
    token = token.substring(0, half);
  }

  writeToken(token);
  stdout.writeln('Token salvo em ${defaultTokenPath()} '
      '(${token.length} caracteres, permissão 600).');
  stdout.writeln('Confira com: gyanburu whoami');
}

Future<void> _whoami(Client client) async {
  // Cheapest authenticated call available — proves the token is accepted.
  await client.importHistory.list();
  stdout.writeln('Token aceito por ${client.host}');
}

String _month(List<String> rest) {
  if (rest.isEmpty) throw StateError('Informe o mês no formato YYYY-MM.');
  final month = rest.first;
  if (!RegExp(r'^\d{4}-\d{2}$').hasMatch(month)) {
    throw StateError('Mês inválido: $month (esperado YYYY-MM).');
  }
  return month;
}

Future<void> _importOfx(Client client, List<String> paths) async {
  if (paths.isEmpty) throw StateError('Informe ao menos um arquivo OFX.');

  for (final path in paths) {
    final file = File(path);
    if (!file.existsSync()) {
      stderr.writeln('Arquivo não encontrado: $path');
      continue;
    }
    final content = file.readAsStringSync();
    final name = file.uri.pathSegments.last;

    stdout.writeln('Importando $name...');
    final result = await client.ofxImport.importOfx(content, name);
    stdout.writeln('  período .......... '
        '${_date(result.statementStart)} a ${_date(result.statementEnd)}');
    stdout.writeln('  no arquivo ....... ${result.totalTransactions}');
    stdout.writeln('  novas ............ ${result.newTransactions}');
    stdout.writeln('  duplicadas ....... ${result.skippedDuplicates}');
    stdout.writeln('  créditos pulados . ${result.skippedCredits}');
  }
}

Future<void> _entries(Client client, String month) async {
  final entries = await client.monthlyEntry.listByMonth(month);
  if (entries.isEmpty) {
    stdout.writeln('Nenhum lançamento em $month.');
    return;
  }

  entries.sort((a, b) {
    final byType = a.type.name.compareTo(b.type.name);
    if (byType != 0) return byType;
    return (a.dueDate ?? DateTime(2100))
        .compareTo(b.dueDate ?? DateTime(2100));
  });

  stdout.writeln('Lançamentos de $month\n');
  stdout.writeln('  id  cat  tipo     valor        venc.       pg  cf  vr  nome');
  var income = 0.0;
  var expense = 0.0;
  var openExpense = 0.0;

  for (final e in entries) {
    if (e.type == EntryType.income) {
      income += e.amount;
    } else {
      expense += e.amount;
      if (!e.paid) openExpense += e.amount;
    }
    stdout.writeln('  ${_pad(e.id.toString(), 4)}'
        '${_pad(e.categoryId.toString(), 5)}'
        '${_pad(e.type.name, 9)}'
        '${_pad(_money(e.amount), 13)}'
        '${_pad(_date(e.dueDate), 12)}'
        '${_flag(e.paid)}  ${_flag(e.confirmed)}  ${_flag(e.variable)}  '
        '${e.name}');
  }

  stdout.writeln('\n  receitas ......... ${_money(income)}');
  stdout.writeln('  despesas ......... ${_money(expense)}');
  stdout.writeln('  em aberto ........ ${_money(openExpense)}');
  stdout.writeln('  saldo previsto ... ${_money(income - expense)}');
  stdout.writeln('\n  pg = pago | cf = confirmado | vr = variável');
}

Future<void> _entrySet(Client client, ArgResults cmd) async {
  final month = cmd['month'] as String;
  final id = int.tryParse(cmd['id'] as String);
  if (id == null) throw StateError('Id inválido.');

  final entries = await client.monthlyEntry.listByMonth(month);
  final entry = entries.where((e) => e.id == id).firstOrNull;
  if (entry == null) {
    throw StateError('Lançamento $id não encontrado em $month.');
  }

  final before = '${entry.name} ${_money(entry.amount)} '
      'venc=${_date(entry.dueDate)} pago=${entry.paid} '
      'var=${entry.variable} conf=${entry.confirmed}';

  if (cmd['name'] != null) entry.name = cmd['name'] as String;
  if (cmd['amount'] != null) {
    entry.amount = _parseAmount(cmd['amount'] as String, 'amount');
  }
  if (cmd['due'] != null) {
    entry.dueDate = DateTime.parse(cmd['due'] as String);
  }
  if (cmd['variable'] != null) entry.variable = cmd['variable'] as bool;
  if (cmd['confirmed'] != null) entry.confirmed = cmd['confirmed'] as bool;
  if (cmd['paid-amount'] != null) {
    entry.paidAmount = _parseAmount(cmd['paid-amount'] as String, 'paid-amount');
  }
  if (cmd['payment-note'] != null) {
    entry.paymentNote = cmd['payment-note'] as String;
  }
  if (cmd['paid'] != null) {
    entry.paid = cmd['paid'] as bool;
    if (entry.paid) {
      entry.paidAt ??= DateTime.now();
      entry.paidAmount ??= entry.amount;
    } else {
      entry.paidAt = null;
      entry.paidAmount = null;
    }
  }

  final saved = await client.monthlyEntry.update(entry);
  stdout.writeln('antes:  $before');
  stdout.writeln('depois: ${saved.name} ${_money(saved.amount)} '
      'venc=${_date(saved.dueDate)} pago=${saved.paid} '
      'var=${saved.variable} conf=${saved.confirmed}');
  if (saved.recurrent) {
    stdout.writeln('\nLançamento recorrente: a alteração foi propagada para '
        'os meses futuros já materializados (exceto os já pagos).');
  }
}

Future<void> _entryNew(Client client, ArgResults cmd) async {
  final categoryId = int.tryParse(cmd['category-id'] as String);
  if (categoryId == null) throw StateError('--category-id inválido.');

  final entry = MonthlyEntry(
    userId: UuidValue.fromString('00000000-0000-0000-0000-000000000000'),
    categoryId: categoryId,
    name: cmd['name'] as String,
    type: (cmd['type'] as String) == 'income'
        ? EntryType.income
        : EntryType.expense,
    amount: _parseAmount(cmd['amount'] as String, 'amount'),
    month: cmd['month'] as String,
    recurrent: cmd['recurrent'] as bool,
    variable: cmd['variable'] as bool,
    confirmed: cmd['confirmed'] as bool,
    dueDate:
        cmd['due'] == null ? null : DateTime.parse(cmd['due'] as String),
    paid: cmd['paid'] as bool,
  );

  final saved = await client.monthlyEntry.create(entry);
  stdout.writeln('Criado #${saved.id}: ${saved.name} ${_money(saved.amount)} '
      '(${saved.type.name}) venc=${_date(saved.dueDate)} '
      'em ${saved.month}');
  if (saved.recurrent) {
    stdout.writeln('Recorrente: copiado para os meses futuros já abertos.');
  }
}

Future<void> _entryDelete(Client client, List<String> rest) async {
  if (rest.isEmpty) throw StateError('Informe o id do lançamento.');
  final id = int.tryParse(rest.first);
  if (id == null) throw StateError('Id inválido.');
  await client.monthlyEntry.delete(id);
  stdout.writeln('Lançamento $id removido.');
}

Future<void> _categories(Client client) async {
  final categories = await client.category.list();
  for (final c in categories) {
    stdout.writeln('  ${_pad(c.id.toString(), 5)}${c.name}');
  }
}

Future<void> _transactions(
  Client client,
  String? month, {
  required bool onlyUncategorized,
}) async {
  final txns = month == null
      ? await client.transaction.list()
      : await client.transaction.listByMonth(DateTime.parse('$month-01'));

  final filtered = onlyUncategorized
      ? txns
          .where((t) => t.category.trim().isEmpty && t.kind != 'topup')
          .toList()
      : txns;

  if (filtered.isEmpty) {
    stdout.writeln(onlyUncategorized
        ? 'Nenhuma transação sem categoria.'
        : 'Nenhuma transação encontrada.');
    return;
  }

  filtered.sort((a, b) => a.occurredAt.compareTo(b.occurredAt));

  var total = 0.0;
  for (final t in filtered) {
    total += t.amount;
    stdout.writeln('  ${_pad(t.id.toString(), 6)}'
        '${_pad(_date(t.occurredAt), 12)}'
        '${_pad(_money(t.amount), 13)}'
        '${_pad(t.category.isEmpty ? '-' : t.category, 15)}'
        '${t.displayName ?? t.merchantName}');
  }
  stdout.writeln('\n  ${filtered.length} transações · total ${_money(total)}');
}

Future<void> _imports(Client client) async {
  final history = await client.importHistory.list();
  if (history.isEmpty) {
    stdout.writeln('Nenhuma importação registrada.');
    return;
  }
  for (final h in history) {
    stdout.writeln('  ${_pad(_date(h.importedAt), 12)}'
        '${_pad('${h.newTransactions} novas', 12)}'
        '${_pad('${h.skippedDuplicates} dup', 10)}'
        '${h.fileName}');
  }
}

String _walletSlug(ArgResults cmd) {
  final slug = cmd['wallet'] as String;
  return slug == 'home' ? 'home-office' : slug;
}

DateTime? _dayOption(ArgResults cmd, {bool endOfDay = false}) {
  final raw = cmd['date'] as String?;
  if (raw == null) return null;
  final day = DateTime.parse(raw);
  return endOfDay
      ? DateTime(day.year, day.month, day.day, 23, 59, 59)
      : day;
}

Future<void> _caju(Client client, List<String> rest) async {
  final now = DateTime.now();
  final month = rest.isEmpty
      ? '${now.year.toString().padLeft(4, '0')}-'
          '${now.month.toString().padLeft(2, '0')}'
      : _month(rest);
  final monthDate = DateTime.parse('$month-01');

  final summaries = await client.wallet.summaries(monthDate);
  final walletNames = {
    for (final s in summaries) s.wallet.id: s.wallet.name,
  };

  stdout.writeln('Caju — $month\n');
  var totalBalance = 0.0;
  for (final s in summaries) {
    totalBalance += s.balance;
    final topupInfo = s.wallet.monthlyTopupAmount == null
        ? ''
        : ' · recarga padrão ${_money(s.wallet.monthlyTopupAmount!)}';
    stdout.writeln('  ${s.wallet.name} (${s.wallet.slug})');
    stdout.writeln('    saldo ............ ${_money(s.balance)}');
    stdout.writeln('    gasto no mês ..... ${_money(s.monthSpent)}');
    stdout.writeln('    recarregado ...... ${_money(s.monthToppedUp)}'
        '$topupInfo');
  }
  stdout.writeln('  total ${_money(totalBalance)}');

  final txns = await client.wallet.monthTransactions(monthDate);
  if (txns.isEmpty) {
    stdout.writeln('\nNenhum lançamento em $month.');
    return;
  }
  stdout.writeln('');
  for (final t in txns.reversed) {
    final signed = t.kind == 'expense' ? -t.amount : t.amount;
    stdout.writeln('  ${_pad(t.id.toString(), 6)}'
        '${_pad(_date(t.occurredAt), 12)}'
        '${_pad(_money(signed), 13)}'
        '${_pad(walletNames[t.walletId] ?? '?', 18)}'
        '${_pad(t.category.isEmpty ? '-' : t.category, 15)}'
        '${t.displayName ?? t.merchantName}');
  }
}

Future<void> _cajuSpend(Client client, ArgResults cmd) async {
  final categoryRaw = cmd['category-id'] as String?;
  int? categoryId;
  if (categoryRaw != null) {
    categoryId = int.tryParse(categoryRaw);
    if (categoryId == null) throw StateError('--category-id inválido.');
  }

  final tx = await client.wallet.spend(
    _walletSlug(cmd),
    _parseAmount(cmd['amount'] as String, 'amount'),
    cmd['name'] as String,
    categoryId,
    _dayOption(cmd),
    cmd['desc'] as String?,
  );
  stdout.writeln('Gasto #${tx.id}: ${_money(tx.amount)} '
      '${tx.displayName ?? tx.merchantName} '
      '(${tx.category.isEmpty ? 'sem categoria' : tx.category}) '
      'em ${_date(tx.occurredAt)}');
}

Future<void> _cajuTopup(Client client, ArgResults cmd) async {
  final amountRaw = cmd['amount'] as String?;
  final tx = await client.wallet.topup(
    _walletSlug(cmd),
    amountRaw == null ? null : _parseAmount(amountRaw, 'amount'),
    _dayOption(cmd),
    cmd['desc'] as String?,
  );
  stdout.writeln('Recarga #${tx.id}: ${_money(tx.amount)} '
      'em ${_date(tx.occurredAt)}');
}

Future<void> _cajuSetBalance(Client client, ArgResults cmd) async {
  final wallet = await client.wallet.setBalance(
    _walletSlug(cmd),
    _parseAmount(cmd['amount'] as String, 'amount'),
    _dayOption(cmd, endOfDay: true),
  );
  stdout.writeln('${wallet.name}: saldo ancorado em '
      '${_money(wallet.anchorBalance)} '
      '(${_date(wallet.anchorDate)}). Lançamentos posteriores à âncora '
      'continuam contando.');
}

Future<void> _cajuSetTopup(Client client, ArgResults cmd) async {
  final amountRaw = cmd['amount'] as String?;
  final wallet = await client.wallet.setMonthlyTopup(
    _walletSlug(cmd),
    amountRaw == null ? null : _parseAmount(amountRaw, 'amount'),
  );
  stdout.writeln(wallet.monthlyTopupAmount == null
      ? '${wallet.name}: recarga mensal padrão removida.'
      : '${wallet.name}: recarga mensal padrão de '
          '${_money(wallet.monthlyTopupAmount!)}.');
}

Future<void> _cajuDelete(Client client, List<String> rest) async {
  if (rest.isEmpty) throw StateError('Informe o id do lançamento.');
  final id = int.tryParse(rest.first);
  if (id == null) throw StateError('Id inválido.');
  await client.wallet.deleteTransaction(id);
  stdout.writeln('Lançamento $id removido.');
}

double _parseAmount(String raw, String field) {
  final value = double.tryParse(raw.replaceAll(',', '.'));
  if (value == null) throw StateError('Valor inválido em --$field: $raw');
  return value;
}

String _money(double value) => 'R\$ ${value.toStringAsFixed(2)}';

String _date(DateTime? value) {
  if (value == null) return '-';
  final d = value.toLocal();
  return '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/${d.year}';
}

String _flag(bool value) => value ? 'x' : '.';

String _pad(String value, int width) => value.padRight(width);
