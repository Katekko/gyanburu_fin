import 'dart:typed_data';

/// A bitmap read from the system clipboard, paired with its MIME type.
typedef ClipboardImage = ({Uint8List bytes, String contentType});

/// Native fallback: there is no web clipboard image access here, so callers get
/// null and surface a "no image on the clipboard" message.
Future<ClipboardImage?> readClipboardImage() async => null;
