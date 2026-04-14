String buildRegistrationEmailHtml({required String code}) {
  return _renderCodeEmail(
    preheader: 'Seu código de verificação chegou.',
    title: 'Bem-vindo ao Gyanburu Fin',
    message:
        'Use o código abaixo pra concluir seu cadastro. Ele expira em alguns minutos.',
    code: code,
    footerNote:
        'Se você não solicitou esse código, pode ignorar este email — ninguém mais terá acesso à sua conta.',
  );
}

String buildPasswordResetEmailHtml({required String code}) {
  return _renderCodeEmail(
    preheader: 'Redefinição de senha solicitada.',
    title: 'Redefinir sua senha',
    message:
        'Use o código abaixo pra criar uma nova senha. Ele expira em alguns minutos.',
    code: code,
    footerNote:
        'Se não foi você quem pediu, ignore este email — sua senha permanece inalterada.',
  );
}

String _renderCodeEmail({
  required String preheader,
  required String title,
  required String message,
  required String code,
  required String footerNote,
}) {
  return '''
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$title</title>
</head>
<body style="margin:0;padding:0;background-color:#121212;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;color:#E0E0E0;">
  <span style="display:none!important;visibility:hidden;opacity:0;color:transparent;height:0;width:0;">$preheader</span>
  <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="background-color:#121212;padding:40px 16px;">
    <tr>
      <td align="center">
        <table role="presentation" width="480" cellspacing="0" cellpadding="0" border="0" style="max-width:480px;background-color:#1E1E1E;border-radius:16px;overflow:hidden;">
          <tr>
            <td style="background:linear-gradient(135deg,#6200EE 0%,#FF9800 100%);padding:32px 32px 24px 32px;">
              <div style="font-size:14px;font-weight:600;letter-spacing:2px;text-transform:uppercase;color:rgba(255,255,255,0.85);">Gyanburu Fin</div>
              <h1 style="margin:12px 0 0 0;font-size:24px;font-weight:700;color:#FFFFFF;line-height:1.3;">$title</h1>
            </td>
          </tr>
          <tr>
            <td style="padding:32px;">
              <p style="margin:0 0 24px 0;font-size:15px;line-height:1.6;color:#E0E0E0;">$message</p>
              <div style="background-color:#2C2C2C;border:1px solid #383838;border-radius:12px;padding:24px;text-align:center;">
                <div style="font-size:12px;font-weight:600;letter-spacing:1.5px;text-transform:uppercase;color:#9E9E9E;margin-bottom:8px;">Seu código</div>
                <div style="font-size:36px;font-weight:700;letter-spacing:8px;color:#FFFFFF;font-family:'Courier New',monospace;">$code</div>
              </div>
              <p style="margin:24px 0 0 0;font-size:13px;line-height:1.6;color:#9E9E9E;">$footerNote</p>
            </td>
          </tr>
          <tr>
            <td style="padding:0 32px 32px 32px;">
              <div style="border-top:1px solid #2C2C2C;padding-top:20px;font-size:12px;color:#616161;text-align:center;">
                Gyanburu Fin &middot; suas finanças, sua jornada.
              </div>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
''';
}
