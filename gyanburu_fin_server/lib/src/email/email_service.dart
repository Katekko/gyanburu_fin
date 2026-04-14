import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';

import 'email_templates.dart';

class EmailService {
  static SmtpServer? _smtpServer;
  static String? _fromEmail;
  static String? _fromName;
  static bool _initialized = false;

  static void _ensureInitialized(Session session) {
    if (_initialized) return;
    _initialized = true;

    final host = session.passwords['smtpHost'];
    final portStr = session.passwords['smtpPort'];
    final username = session.passwords['smtpUsername'];
    final password = session.passwords['smtpPassword'];
    final fromEmail = session.passwords['smtpFromEmail'];
    final fromName = session.passwords['smtpFromName'];

    if (host == null ||
        portStr == null ||
        username == null ||
        password == null ||
        fromEmail == null) {
      session.log(
        '[Email] SMTP not configured — falling back to log-only delivery',
        level: LogLevel.warning,
      );
      return;
    }

    _smtpServer = SmtpServer(
      host,
      port: int.parse(portStr),
      username: username,
      password: password,
      ssl: false,
      allowInsecure: false,
    );
    _fromEmail = fromEmail;
    _fromName = fromName ?? 'Gyanburu Fin';
  }

  static Future<void> sendRegistrationCode(
    Session session, {
    required String toEmail,
    required String code,
  }) async {
    await _send(
      session,
      toEmail: toEmail,
      subject: 'Seu código de verificação — Gyanburu Fin',
      html: buildRegistrationEmailHtml(code: code),
      text:
          'Bem-vindo ao Gyanburu Fin! Seu código de verificação é: $code. '
          'Ele expira em alguns minutos.',
    );
  }

  static Future<void> sendPasswordResetCode(
    Session session, {
    required String toEmail,
    required String code,
  }) async {
    await _send(
      session,
      toEmail: toEmail,
      subject: 'Redefinição de senha — Gyanburu Fin',
      html: buildPasswordResetEmailHtml(code: code),
      text:
          'Você pediu pra redefinir sua senha. Seu código é: $code. '
          'Se não foi você, ignore este email.',
    );
  }

  static Future<void> _send(
    Session session, {
    required String toEmail,
    required String subject,
    required String html,
    required String text,
  }) async {
    _ensureInitialized(session);

    final server = _smtpServer;
    final from = _fromEmail;
    if (server == null || from == null) {
      session.log(
        '[Email] SMTP not configured; skipping send to $toEmail (subject: $subject)',
        level: LogLevel.warning,
      );
      return;
    }

    final message = mailer.Message()
      ..from = mailer.Address(from, _fromName)
      ..recipients.add(toEmail)
      ..subject = subject
      ..text = text
      ..html = html;

    try {
      await mailer.send(message, server);
      session.log('[Email] Sent to $toEmail: $subject');
    } catch (e, stack) {
      session.log(
        '[Email] Failed to send to $toEmail: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: stack,
      );
    }
  }
}
