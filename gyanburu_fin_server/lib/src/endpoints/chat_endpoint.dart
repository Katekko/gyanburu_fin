import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class ChatEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Future<String> sendMessage(
    Session session,
    List<ChatMessage> history,
    String userMessage,
  ) async {
    final userId = _userId(session);
    final apiKey = session.passwords['anthropicApiKey'] ?? '';
    if (apiKey.isEmpty) throw StateError('Anthropic API key not configured');

    final context = await _buildFinancialContext(session, userId);

    final messages = [
      ...history.map((m) => {'role': m.role, 'content': m.content}),
      {'role': 'user', 'content': userMessage},
    ];

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': 'claude-sonnet-4-6',
        'max_tokens': 1024,
        'system': '''Você é um assistente financeiro pessoal integrado ao Gyanburu Fin.
Responda sempre em português do Brasil. Seja conciso e direto.
Valores negativos indicam despesas; positivos indicam receitas ou entradas.
Transações do tipo "[Pagamento Fatura]" são pagamentos de cartão de crédito — não são despesas reais, são apenas transferências entre conta e cartão.

$context''',
        'messages': messages,
      }),
    );

    if (response.statusCode != 200) {
      throw StateError(
          'Claude API error ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['content'] as List).first['text'] as String;
  }

  Future<String> _buildFinancialContext(
    Session session,
    UuidValue userId,
  ) async {
    final now = DateTime.now();
    final fourMonthsAgo = now.subtract(const Duration(days: 122));
    final nextMonth = DateTime(now.year, now.month + 1);

    final transactions = await FinancialTransaction.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.occurredAt.between(fourMonthsAgo, nextMonth),
      orderBy: (t) => t.occurredAt,
      orderDescending: true,
    );

    final categories = await Category.db.find(
      session,
      where: (c) => c.userId.equals(userId),
    );

    final sb = StringBuffer();
    sb.writeln(
        'Data de hoje: ${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}');
    sb.writeln();
    sb.writeln(
        'Categorias cadastradas: ${categories.map((c) => c.name).join(', ')}');
    sb.writeln();
    sb.writeln('Transações (últimos 4 meses):');

    for (final t in transactions) {
      final display = (t.displayName?.isNotEmpty == true)
          ? t.displayName!
          : t.merchantName;
      final cat = t.category.isNotEmpty ? t.category : 'Sem categoria';
      final date =
          '${t.occurredAt.year}-${t.occurredAt.month.toString().padLeft(2, '0')}-${t.occurredAt.day.toString().padLeft(2, '0')}';
      final amountStr =
          '${t.amount >= 0 ? '+' : '-'}R\$${t.amount.abs().toStringAsFixed(2)}';
      final kindTag = t.kind == 'fatura_payment' ? ' [Pagamento Fatura]' : '';
      final sourceTag = t.source == 'credit_card'
          ? ' [Cartão]'
          : t.source == 'bank'
              ? ' [Conta]'
              : '';
      sb.writeln('$date | $display | $cat$kindTag$sourceTag | $amountStr');
    }

    // Monthly summary (excluding fatura_payment to avoid double-counting)
    sb.writeln();
    sb.writeln('Resumo mensal (sem pagamentos de fatura):');
    final monthlyIncome = <String, double>{};
    final monthlyExpense = <String, double>{};
    for (final t in transactions) {
      if (t.kind == 'fatura_payment') continue;
      final key =
          '${t.occurredAt.year}-${t.occurredAt.month.toString().padLeft(2, '0')}';
      if (t.amount >= 0) {
        monthlyIncome[key] = (monthlyIncome[key] ?? 0) + t.amount;
      } else {
        monthlyExpense[key] = (monthlyExpense[key] ?? 0) + t.amount.abs();
      }
    }
    final months = {...monthlyIncome.keys, ...monthlyExpense.keys}.toList()
      ..sort();
    for (final m in months) {
      final inc = monthlyIncome[m] ?? 0;
      final exp = monthlyExpense[m] ?? 0;
      final net = inc - exp;
      sb.writeln(
          '$m: receitas +R\$${inc.toStringAsFixed(2)} | despesas -R\$${exp.toStringAsFixed(2)} | saldo ${net >= 0 ? '+' : ''}R\$${net.toStringAsFixed(2)}');
    }

    return sb.toString();
  }
}
