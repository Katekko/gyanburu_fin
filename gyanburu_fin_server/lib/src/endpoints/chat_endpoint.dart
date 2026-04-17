import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

const _model = 'claude-sonnet-4-6';
const _apiUrl = 'https://api.anthropic.com/v1/messages';

final _tools = [
  {
    'name': 'categorize_merchant',
    'description':
        'Categoriza todas as transações de um comerciante e cria (ou atualiza) '
            'uma regra de categoria para transações futuras.',
    'input_schema': {
      'type': 'object',
      'properties': {
        'merchant_name': {
          'type': 'string',
          'description':
              'Nome exato do comerciante como aparece nas transações.',
        },
        'category_name': {
          'type': 'string',
          'description':
              'Nome da categoria a ser aplicada. Deve ser uma das categorias existentes, '
                  'a menos que create_category tenha sido chamado antes nesta sequência.',
        },
        'propagate': {
          'type': 'boolean',
          'description':
              'Se true, aplica a categoria a todas as transações existentes deste comerciante.',
        },
      },
      'required': ['merchant_name', 'category_name', 'propagate'],
    },
  },
  {
    'name': 'create_category',
    'description': 'Cria uma nova categoria de gastos.',
    'input_schema': {
      'type': 'object',
      'properties': {
        'name': {'type': 'string', 'description': 'Nome da categoria.'},
        'icon': {
          'type': 'string',
          'description':
              'Nome do ícone Material (ex: restaurant, directions_car, shopping_cart, '
                  'home, sports_esports, local_hospital, school, flight).',
        },
        'color': {
          'type': 'string',
          'description':
              'Cor em hexadecimal sem o # (ex: FF7043, 42A5F5, 66BB6A).',
        },
      },
      'required': ['name', 'icon', 'color'],
    },
  },
];

class ChatEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Map<String, String> _headers(String apiKey) => {
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      };

  Future<ChatResponse> sendMessage(
    Session session,
    List<ChatMessage> history,
    String userMessage,
  ) async {
    final userId = _userId(session);
    final apiKey = session.passwords['anthropicApiKey'] ?? '';
    if (apiKey.isEmpty) throw StateError('Anthropic API key not configured');

    final context = await _buildFinancialContext(session, userId);

    final systemPrompt =
        '''Você é um assistente financeiro pessoal integrado ao Gyanburu Fin.
Responda sempre em português do Brasil. Seja conciso e direto.
Valores negativos indicam despesas; positivos indicam receitas ou entradas.
Transações do tipo "[Pagamento Fatura]" são pagamentos de cartão — não são despesas reais.

Você tem acesso a duas ferramentas para modificar dados:
- categorize_merchant: categoriza transações de um comerciante e cria a regra
- create_category: cria uma nova categoria

IMPORTANTE: Quando usar ferramentas, suas ações ficam pendentes de confirmação do usuário antes de serem executadas. Após registrar as ações, explique o que será feito de forma resumida e peça confirmação.

$context''';

    final messages = [
      ...history.map((m) => {'role': m.role, 'content': m.content}),
      {'role': 'user', 'content': userMessage},
    ];

    // First call — Claude may call tools
    final firstResponse = await http.post(
      Uri.parse(_apiUrl),
      headers: _headers(apiKey),
      body: jsonEncode({
        'model': _model,
        'max_tokens': 2048,
        'system': systemPrompt,
        'tools': _tools,
        'messages': messages,
      }),
    );

    if (firstResponse.statusCode != 200) {
      throw StateError(
          'Claude API error ${firstResponse.statusCode}: ${firstResponse.body}');
    }

    final firstData =
        jsonDecode(firstResponse.body) as Map<String, dynamic>;
    final firstContent = firstData['content'] as List;
    final toolUseBlocks =
        firstContent.where((c) => c['type'] == 'tool_use').toList();

    // No tools called → return plain reply
    if (toolUseBlocks.isEmpty) {
      final text = (firstContent.firstWhere(
        (c) => c['type'] == 'text',
        orElse: () => {'text': ''},
      ))['text'] as String;
      return ChatResponse(reply: text, pendingActions: []);
    }

    // Build pending actions from tool calls
    final pendingActions = <PendingAction>[];
    final toolResults = <Map<String, dynamic>>[];

    for (final block in toolUseBlocks) {
      final name = block['name'] as String;
      final input = block['input'] as Map<String, dynamic>;
      final id = block['id'] as String;

      if (name == 'create_category') {
        pendingActions.add(PendingAction(
          type: 'create_category',
          categoryName: input['name'] as String,
          categoryIcon: input['icon'] as String,
          categoryColor: input['color'] as String,
        ));
      } else if (name == 'categorize_merchant') {
        pendingActions.add(PendingAction(
          type: 'categorize_merchant',
          merchantName: input['merchant_name'] as String,
          categoryName: input['category_name'] as String,
          propagate: input['propagate'] as bool? ?? true,
        ));
      }

      toolResults.add({
        'type': 'tool_result',
        'tool_use_id': id,
        'content': 'Ação registrada, aguardando confirmação do usuário.',
      });
    }

    // Second call — send tool results so Claude generates a confirmation message
    final secondResponse = await http.post(
      Uri.parse(_apiUrl),
      headers: _headers(apiKey),
      body: jsonEncode({
        'model': _model,
        'max_tokens': 1024,
        'system': systemPrompt,
        'tools': _tools,
        'messages': [
          ...messages,
          {'role': 'assistant', 'content': firstContent},
          {'role': 'user', 'content': toolResults},
        ],
      }),
    );

    if (secondResponse.statusCode != 200) {
      throw StateError(
          'Claude API error ${secondResponse.statusCode}: ${secondResponse.body}');
    }

    final secondData =
        jsonDecode(secondResponse.body) as Map<String, dynamic>;
    final secondContent = secondData['content'] as List;
    final confirmationText = (secondContent.firstWhere(
      (c) => c['type'] == 'text',
      orElse: () => {'text': ''},
    ))['text'] as String;

    return ChatResponse(
      reply: confirmationText,
      pendingActions: pendingActions,
    );
  }

  Future<String> executeActions(
    Session session,
    List<PendingAction> actions,
  ) async {
    final userId = _userId(session);
    final results = <String>[];

    for (final action in actions) {
      if (action.type == 'create_category') {
        final name = action.categoryName!;
        final existing = (await Category.db.find(
          session,
          where: (c) => c.userId.equals(userId) & c.name.equals(name),
        ))
            .firstOrNull;

        if (existing == null) {
          await Category.db.insertRow(
            session,
            Category(
              userId: userId,
              name: name,
              icon: action.categoryIcon ?? 'label',
              color: action.categoryColor ?? '9E9E9E',
            ),
          );
          results.add('Categoria "$name" criada');
        } else {
          results.add('Categoria "$name" já existia');
        }
      } else if (action.type == 'categorize_merchant') {
        final merchant = action.merchantName!;
        final categoryName = action.categoryName!;
        final propagate = action.propagate ?? true;

        final cat = (await Category.db.find(
          session,
          where: (c) =>
              c.userId.equals(userId) & c.name.equals(categoryName),
        ))
            .firstOrNull;

        int count = 0;
        if (propagate) {
          final transactions = await FinancialTransaction.db.find(
            session,
            where: (t) =>
                t.userId.equals(userId) &
                t.merchantName.equals(merchant),
          );
          for (final tx in transactions) {
            tx.category = categoryName;
            await FinancialTransaction.db.updateRow(session, tx);
          }
          count = transactions.length;
        }

        // Upsert category rule
        final existingRule = (await CategoryRule.db.find(
          session,
          where: (r) =>
              r.userId.equals(userId) &
              r.merchantPattern.equals(merchant),
        ))
            .firstOrNull;

        if (existingRule != null) {
          existingRule.categoryId = cat?.id;
          await CategoryRule.db.updateRow(session, existingRule);
        } else {
          await CategoryRule.db.insertRow(
            session,
            CategoryRule(
              userId: userId,
              merchantPattern: merchant,
              categoryId: cat?.id,
            ),
          );
        }

        results.add(
            '$count transações de "$merchant" → "$categoryName"');
      }
    }

    return '**Ações executadas:**\n\n'
        '${results.map((r) => '- $r').join('\n')}';
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
      sb.writeln(
          '[ID:${t.id}] $date | $display | $cat$kindTag$sourceTag | $amountStr');
    }

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
        monthlyExpense[key] =
            (monthlyExpense[key] ?? 0) + t.amount.abs();
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
