import 'package:flutter/services.dart';

/// Native (mobile/desktop) implementation — Flutter's clipboard works fine here.
Future<void> copyToClipboard(String text) {
  return Clipboard.setData(ClipboardData(text: text));
}
