import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:markdown/markdown.dart' as md;

import '../main.dart' show client;
import '../theme/app_theme.dart';

class ChatPanel extends StatefulWidget {
  const ChatPanel({
    super.key,
    this.onClose,
    this.onToggleFullscreen,
    this.isFullscreen = false,
  });

  final VoidCallback? onClose;
  final VoidCallback? onToggleFullscreen;
  final bool isFullscreen;

  @override
  State<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> {
  final List<ChatMessage> _history = [];
  List<PendingAction> _pendingActions = [];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  bool _loading = false;

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _loading) return;

    _controller.clear();
    _focusNode.requestFocus();
    final historyBeforeNewMessage = List<ChatMessage>.from(_history);
    setState(() {
      _history.add(ChatMessage(role: 'user', content: text));
      _pendingActions = [];
      _loading = true;
    });
    _scrollToBottom();

    try {
      final response =
          await client.chat.sendMessage(historyBeforeNewMessage, text);
      setState(() {
        _history.add(ChatMessage(role: 'assistant', content: response.reply));
        _pendingActions = response.pendingActions;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _history.add(ChatMessage(
          role: 'assistant',
          content: 'Erro ao processar sua mensagem. Tente novamente.',
        ));
        _loading = false;
      });
    }
    _scrollToBottom();
  }

  Future<void> _executeActions() async {
    final actions = List<PendingAction>.from(_pendingActions);
    setState(() {
      _pendingActions = [];
      _loading = true;
    });
    _scrollToBottom();

    try {
      final result = await client.chat.executeActions(actions);
      setState(() {
        _history.add(ChatMessage(role: 'assistant', content: result));
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _history.add(ChatMessage(
          role: 'assistant',
          content: 'Erro ao executar as ações. Tente novamente.',
        ));
        _loading = false;
      });
    }
    _scrollToBottom();
  }

  void _cancelActions() {
    setState(() => _pendingActions = []);
    _history.add(ChatMessage(role: 'assistant', content: 'Ações canceladas.'));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(child: _buildMessages()),
        const Divider(height: 1),
        _buildInput(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.deepPurple,
      child: Row(
        children: [
          const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Assistente Financeiro',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: Colors.white70, size: 18),
              tooltip: 'Limpar conversa',
              onPressed: () =>
                  setState(() {
                    _history.clear();
                    _pendingActions = [];
                  }),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          if (_history.isNotEmpty) const SizedBox(width: 8),
          if (widget.onToggleFullscreen != null)
            IconButton(
              icon: Icon(
                widget.isFullscreen
                    ? Icons.close_fullscreen
                    : Icons.open_in_full,
                color: Colors.white70,
                size: 18,
              ),
              tooltip: widget.isFullscreen ? 'Reduzir' : 'Expandir',
              onPressed: widget.onToggleFullscreen,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          const SizedBox(width: 8),
          if (widget.onClose != null)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white70, size: 18),
              tooltip: 'Fechar',
              onPressed: widget.onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    if (_history.isEmpty && !_loading && _pendingActions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chat_bubble_outline,
                  size: 48, color: AppColors.textMuted),
              const SizedBox(height: 12),
              Text(
                'Pergunte sobre suas finanças',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '"Quanto gastei com alimentação esse mês?"\n"Categoriza os UBER como Transporte"\n"Cria a categoria Moto e categoriza a LAGUNA"',
                style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final hasPending = _pendingActions.isNotEmpty;
    final itemCount =
        _history.length + (hasPending ? 1 : 0) + (_loading ? 1 : 0);

    return SelectionArea(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: itemCount,
        itemBuilder: (context, i) {
          if (i < _history.length) return _ChatBubble(message: _history[i]);
          if (hasPending && i == _history.length) {
            return _PendingActionsCard(
              actions: _pendingActions,
              onConfirm: _executeActions,
              onCancel: _cancelActions,
            );
          }
          return const _TypingIndicator();
        },
      ),
    );
  }

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Pergunte algo...',
                hintStyle: const TextStyle(fontSize: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                isDense: true,
              ),
              onSubmitted: (_) => _send(),
              maxLines: null,
              textInputAction: TextInputAction.send,
              enabled: !_loading,
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: _loading ? null : _send,
            icon: const Icon(Icons.send_rounded),
            color: AppColors.deepPurple,
            iconSize: 22,
          ),
        ],
      ),
    );
  }
}

// ── Pending actions confirmation card ────────────────────────────────────────

class _PendingActionsCard extends StatelessWidget {
  const _PendingActionsCard({
    required this.actions,
    required this.onConfirm,
    required this.onCancel,
  });

  final List<PendingAction> actions;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  String _describe(PendingAction a) {
    if (a.type == 'create_category') {
      return 'Criar categoria "${a.categoryName}"';
    }
    if (a.type == 'categorize_merchant') {
      final scope = a.propagate == true ? 'todas as transações' : 'novas transações';
      return 'Categorizar "${a.merchantName}" como "${a.categoryName}" ($scope)';
    }
    return a.type;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.deepPurple.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pending_actions_outlined,
                  color: AppColors.deepPurple, size: 16),
              const SizedBox(width: 6),
              Text(
                'Ações pendentes',
                style: TextStyle(
                  color: AppColors.deepPurple,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...actions.map(
            (a) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style:
                          TextStyle(color: Colors.black87, fontSize: 13)),
                  Expanded(
                    child: Text(
                      _describe(a),
                      style: const TextStyle(
                          color: Colors.black87, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onCancel,
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: onConfirm,
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Confirmar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Chat bubble ───────────────────────────────────────────────────────────────

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.deepPurple : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: isUser
            ? Text(
                message.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.4,
                ),
              )
            : MarkdownBody(
                data: message.content,
                selectable: false,
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(
                      color: Colors.black87, fontSize: 13, height: 1.4),
                  strong: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                  em: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontStyle: FontStyle.italic),
                  code: TextStyle(
                      fontSize: 12,
                      backgroundColor: Colors.grey.shade200,
                      fontFamily: 'monospace'),
                  codeblockDecoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6)),
                  listBullet: const TextStyle(
                      color: Colors.black87, fontSize: 13),
                  blockquoteDecoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: AppColors.deepPurple, width: 3)),
                  ),
                  h1: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  h2: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  h3: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                  tableHead: const TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                  tableBody:
                      const TextStyle(color: Colors.black87, fontSize: 12),
                  tableBorder:
                      TableBorder.all(color: const Color(0xFFBDBDBD), width: 1),
                  tableCellsDecoration:
                      const BoxDecoration(color: Colors.white),
                  tableCellsPadding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                ),
              ),
      ),
    );
  }
}

// ── Typing indicator ──────────────────────────────────────────────────────────

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) => Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              final phase = (_ctrl.value - i * 0.2).clamp(0.0, 1.0);
              final opacity =
                  (0.3 + 0.7 * (phase < 0.5 ? phase * 2 : (1 - phase) * 2))
                      .clamp(0.3, 1.0);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.deepPurple.withValues(alpha: opacity),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
