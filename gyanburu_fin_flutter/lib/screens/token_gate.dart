import 'package:flutter/material.dart';

import '../api/token_store.dart';
import '../main.dart';
import '../theme/app_theme.dart';

/// Asks for the access token once per device, then gets out of the way.
///
/// This replaces the old email/password sign-in: there is a single user, so
/// there is nothing to identify — only a secret that proves the request came
/// from the owner.
class TokenGate extends StatefulWidget {
  final Widget child;
  const TokenGate({super.key, required this.child});

  @override
  State<TokenGate> createState() => _TokenGateState();
}

class _TokenGateState extends State<TokenGate> {
  final _controller = TextEditingController();
  bool _loading = true;
  bool _checking = false;
  bool _hasToken = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _restore() async {
    final token = await TokenStore.load();
    if (!mounted) return;
    setState(() {
      _hasToken = token != null;
      _loading = false;
    });
  }

  Future<void> _submit() async {
    final token = _controller.text.trim();
    if (token.isEmpty) {
      setState(() => _error = 'Cole o token para continuar.');
      return;
    }

    setState(() {
      _checking = true;
      _error = null;
    });

    await TokenStore.save(token);
    try {
      // Cheap authenticated call — confirms the server accepts the token
      // before we let the app through.
      await client.importHistory.list();
      if (!mounted) return;
      setState(() {
        _hasToken = true;
        _checking = false;
      });
    } catch (_) {
      await TokenStore.clear();
      if (!mounted) return;
      setState(() {
        _checking = false;
        _error = 'O servidor recusou esse token. Confira e tente de novo.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_hasToken) return widget.child;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Gyanburu Fin',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Cole o token de acesso. Ele fica guardado neste '
                  'dispositivo, então você só faz isso uma vez.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _controller,
                  obscureText: true,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Token de acesso',
                    errorText: _error,
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _checking ? null : _submit(),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _checking ? null : _submit,
                  child: _checking
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Entrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
