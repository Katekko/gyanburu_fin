import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Web implementation. Prefers the legacy `execCommand('copy')` path because it
/// is the most reliable way to copy on a button click: it works in both secure
/// (https/localhost) and insecure (plain http / LAN IP) contexts and needs no
/// clipboard permission, as long as it runs synchronously inside the gesture.
/// Falls back to the async Clipboard API when `execCommand` is unavailable.
Future<void> copyToClipboard(String text) async {
  if (_execCommandCopy(text)) return;

  final clipboard = web.window.navigator.clipboard;
  // `navigator.clipboard` is undefined outside a secure context.
  if (!(clipboard as JSAny?).isUndefinedOrNull) {
    await clipboard.writeText(text).toDart;
  }
}

/// Copies [text] by selecting a throw-away off-screen textarea and running the
/// browser's copy command. Returns whether the copy succeeded. Runs fully
/// synchronously so the surrounding user gesture is still "active".
bool _execCommandCopy(String text) {
  final body = web.document.body;
  if (body == null) return false;

  final textarea = web.HTMLTextAreaElement();
  textarea.value = text;
  textarea.setAttribute('readonly', '');
  textarea.style.setProperty('position', 'fixed');
  textarea.style.setProperty('left', '-9999px');
  textarea.style.setProperty('top', '0');
  body.appendChild(textarea);
  textarea.focus();
  textarea.select();

  bool ok;
  try {
    ok = web.document.execCommand('copy');
  } catch (_) {
    ok = false;
  }
  textarea.remove();
  return ok;
}
