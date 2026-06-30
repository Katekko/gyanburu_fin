import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// A bitmap read from the system clipboard, paired with its MIME type.
typedef ClipboardImage = ({Uint8List bytes, String contentType});

/// Reads the first image on the system clipboard via the async Clipboard API.
/// Returns null when the clipboard holds no image. Throws when the browser
/// blocks the read (e.g. permission denied), which the caller reports.
Future<ClipboardImage?> readClipboardImage() async {
  final clipboard = web.window.navigator.clipboard;
  final items = (await clipboard.read().toDart).toDart;
  for (final item in items) {
    for (final type in item.types.toDart) {
      final mime = type.toDart;
      if (mime.startsWith('image/')) {
        final blob = await item.getType(mime).toDart;
        final buffer = await blob.arrayBuffer().toDart;
        return (bytes: buffer.toDart.asUint8List(), contentType: mime);
      }
    }
  }
  return null;
}
