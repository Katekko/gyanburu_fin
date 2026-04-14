import 'package:flutter/material.dart';
import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../theme/app_theme.dart';

enum _AuthStep {
  login,
  registerStart,
  registerVerify,
  registerComplete,
  resetStart,
  resetVerify,
  resetComplete,
}

class CustomSignInWidget extends StatefulWidget {
  final Client client;
  final VoidCallback onAuthenticated;
  final void Function(String message) onError;

  const CustomSignInWidget({
    super.key,
    required this.client,
    required this.onAuthenticated,
    required this.onError,
  });

  @override
  State<CustomSignInWidget> createState() => _CustomSignInWidgetState();
}

class _CustomSignInWidgetState extends State<CustomSignInWidget> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();

  _AuthStep _step = _AuthStep.login;
  bool _loading = false;
  bool _obscurePassword = true;

  UuidValue? _requestId;
  String? _finishToken;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  void _goTo(_AuthStep step) {
    setState(() {
      _step = step;
      if (step == _AuthStep.login ||
          step == _AuthStep.registerStart ||
          step == _AuthStep.resetStart) {
        _codeCtrl.clear();
        _passwordCtrl.clear();
      }
      if (step == _AuthStep.registerVerify || step == _AuthStep.resetVerify) {
        _codeCtrl.clear();
      }
      if (step == _AuthStep.registerComplete ||
          step == _AuthStep.resetComplete) {
        _passwordCtrl.clear();
      }
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      await action();
    } catch (e) {
      widget.onError(_humanizeError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _humanizeError(Object e) {
    final text = e.toString();
    if (text.contains('invalidCredentials')) {
      return 'Email ou senha incorretos.';
    }
    if (text.contains('tooManyAttempts')) {
      return 'Muitas tentativas. Tente novamente em alguns minutos.';
    }
    if (text.contains('expired')) {
      return 'O código expirou. Solicite um novo.';
    }
    if (text.contains('policyViolation')) {
      return 'Senha fraca. Use ao menos 8 caracteres, com letras e números.';
    }
    if (text.contains('invalid')) {
      return 'Código inválido ou expirado.';
    }
    if (text.contains('blocked')) {
      return 'Conta bloqueada. Entre em contato.';
    }
    return 'Algo deu errado. Tente novamente.';
  }

  Future<void> _login() => _run(() async {
    final success = await widget.client.emailIdp.login(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
    await widget.client.auth.updateSignedInUser(success);
    widget.onAuthenticated();
  });

  Future<void> _startRegistration() => _run(() async {
    _requestId = await widget.client.emailIdp.startRegistration(
      email: _emailCtrl.text.trim(),
    );
    _goTo(_AuthStep.registerVerify);
  });

  Future<void> _verifyRegistration() => _run(() async {
    final id = _requestId;
    if (id == null) throw StateError('Nenhum cadastro em andamento.');
    _finishToken = await widget.client.emailIdp.verifyRegistrationCode(
      accountRequestId: id,
      verificationCode: _codeCtrl.text.trim(),
    );
    _goTo(_AuthStep.registerComplete);
  });

  Future<void> _finishRegistration() => _run(() async {
    final token = _finishToken;
    if (token == null) throw StateError('Token de cadastro ausente.');
    final success = await widget.client.emailIdp.finishRegistration(
      registrationToken: token,
      password: _passwordCtrl.text,
    );
    await widget.client.auth.updateSignedInUser(success);
    widget.onAuthenticated();
  });

  Future<void> _startPasswordReset() => _run(() async {
    _requestId = await widget.client.emailIdp.startPasswordReset(
      email: _emailCtrl.text.trim(),
    );
    _goTo(_AuthStep.resetVerify);
  });

  Future<void> _verifyPasswordReset() => _run(() async {
    final id = _requestId;
    if (id == null) throw StateError('Nenhuma redefinição em andamento.');
    _finishToken = await widget.client.emailIdp.verifyPasswordResetCode(
      passwordResetRequestId: id,
      verificationCode: _codeCtrl.text.trim(),
    );
    _goTo(_AuthStep.resetComplete);
  });

  Future<void> _finishPasswordReset() => _run(() async {
    final token = _finishToken;
    if (token == null) throw StateError('Token de redefinição ausente.');
    await widget.client.emailIdp.finishPasswordReset(
      finishPasswordResetToken: token,
      newPassword: _passwordCtrl.text,
    );
    final success = await widget.client.emailIdp.login(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
    await widget.client.auth.updateSignedInUser(success);
    widget.onAuthenticated();
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(28),
                  child: _buildStep(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.deepPurple, AppColors.vibrantOrange],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gyanburu Fin',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white70,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _headerTitle(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _headerSubtitle(),
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  String _headerTitle() => switch (_step) {
    _AuthStep.login => 'Bem-vindo de volta',
    _AuthStep.registerStart => 'Criar sua conta',
    _AuthStep.registerVerify => 'Verifique seu email',
    _AuthStep.registerComplete => 'Defina sua senha',
    _AuthStep.resetStart => 'Redefinir senha',
    _AuthStep.resetVerify => 'Verifique seu email',
    _AuthStep.resetComplete => 'Nova senha',
  };

  String _headerSubtitle() => switch (_step) {
    _AuthStep.login => 'Entre pra acompanhar suas finanças.',
    _AuthStep.registerStart => 'Use seu email pra começar.',
    _AuthStep.registerVerify => 'Enviamos um código pro seu email.',
    _AuthStep.registerComplete => 'Escolha uma senha segura.',
    _AuthStep.resetStart => 'Informe o email da sua conta.',
    _AuthStep.resetVerify => 'Enviamos um código pro seu email.',
    _AuthStep.resetComplete => 'Escolha uma nova senha.',
  };

  Widget _buildStep() {
    return switch (_step) {
      _AuthStep.login => _loginStep(),
      _AuthStep.registerStart => _emailStep(
        buttonLabel: 'Continuar',
        onSubmit: _startRegistration,
        footer: _linkRow(
          'Já tem uma conta?',
          'Entrar',
          () => _goTo(_AuthStep.login),
        ),
      ),
      _AuthStep.registerVerify => _codeStep(onVerify: _verifyRegistration),
      _AuthStep.registerComplete => _passwordStep(
        buttonLabel: 'Criar conta',
        onSubmit: _finishRegistration,
      ),
      _AuthStep.resetStart => _emailStep(
        buttonLabel: 'Enviar código',
        onSubmit: _startPasswordReset,
        footer: _linkRow(
          'Lembrou a senha?',
          'Voltar',
          () => _goTo(_AuthStep.login),
        ),
      ),
      _AuthStep.resetVerify => _codeStep(onVerify: _verifyPasswordReset),
      _AuthStep.resetComplete => _passwordStep(
        buttonLabel: 'Redefinir senha',
        onSubmit: _finishPasswordReset,
      ),
    };
  }

  Widget _loginStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _emailField(),
        const SizedBox(height: 14),
        _passwordField(),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _loading ? null : () => _goTo(_AuthStep.resetStart),
            child: const Text('Esqueci minha senha'),
          ),
        ),
        const SizedBox(height: 8),
        _primaryButton(label: 'Entrar', onPressed: _login),
        const SizedBox(height: 12),
        _linkRow(
          'Não tem uma conta?',
          'Criar conta',
          () => _goTo(_AuthStep.registerStart),
        ),
      ],
    );
  }

  Widget _emailStep({
    required String buttonLabel,
    required Future<void> Function() onSubmit,
    required Widget footer,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _emailField(),
        const SizedBox(height: 16),
        _primaryButton(label: buttonLabel, onPressed: onSubmit),
        const SizedBox(height: 12),
        footer,
      ],
    );
  }

  Widget _codeStep({required Future<void> Function() onVerify}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _codeCtrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 8,
          style: const TextStyle(
            fontSize: 24,
            letterSpacing: 8,
            fontWeight: FontWeight.w700,
          ),
          decoration: const InputDecoration(
            labelText: 'Código de verificação',
            counterText: '',
          ),
          enabled: !_loading,
        ),
        const SizedBox(height: 8),
        Text(
          'Enviamos pra ${_emailCtrl.text.trim()}. Confira também o spam.',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        _primaryButton(label: 'Verificar', onPressed: onVerify),
        const SizedBox(height: 12),
        _linkRow('Não recebeu?', 'Voltar', () {
          _goTo(
            _step == _AuthStep.registerVerify
                ? _AuthStep.registerStart
                : _AuthStep.resetStart,
          );
        }),
      ],
    );
  }

  Widget _passwordStep({
    required String buttonLabel,
    required Future<void> Function() onSubmit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _passwordField(),
        const SizedBox(height: 8),
        Text(
          'Use ao menos 8 caracteres, com letras e números.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        _primaryButton(label: buttonLabel, onPressed: onSubmit),
      ],
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailCtrl,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      autocorrect: false,
      enabled: !_loading,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.alternate_email),
      ),
    );
  }

  Widget _passwordField() {
    return TextField(
      controller: _passwordCtrl,
      obscureText: _obscurePassword,
      autofillHints: const [AutofillHints.password],
      enabled: !_loading,
      decoration: InputDecoration(
        labelText: 'Senha',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () =>
              setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required Future<void> Function() onPressed,
  }) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: _loading ? null : onPressed,
        child: _loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _linkRow(String label, String action, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        TextButton(
          onPressed: _loading ? null : onTap,
          child: Text(action),
        ),
      ],
    );
  }
}
