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
  transactions <YYYY-MM>     Lista as transações do mês
  uncategorized [YYYY-MM]    Transações sem categoria
  imports                    Histórico de importações

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
  final token = promptHidden('Cole o token (apiToken do passwords.yaml)');
  if (token.trim().isEmpty) {
    stderr.writeln('Token vazio, nada foi salvo.');
    exit(1);
  }
  writeToken(token);
  stdout.writeln('Token salvo em ${defaultTokenPath()} (permissão 600).');
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
  stdout.writeln('  id  tipo     valor        venc.       pg  cf  vr  nome');
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

Future<void> _transactions(
  Client client,
  String? month, {
  required bool onlyUncategorized,
}) async {
  final txns = month == null
      ? await client.transaction.list()
      : await client.transaction.listByMonth(DateTime.parse('$month-01'));

  final filtered = onlyUncategorized
      ? txns.where((t) => t.category.trim().isEmpty).toList()
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
