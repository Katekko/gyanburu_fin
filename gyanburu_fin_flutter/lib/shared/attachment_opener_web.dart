import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Opens raw bytes in a new browser tab via an object URL. The browser renders
/// images and PDFs inline; anything else is offered as a download.
bool openBytesInNewTab(Uint8List bytes, String contentType, String fileName) {
  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: contentType),
  );
  final url = web.URL.createObjectURL(blob);
  web.window.open(url, '_blank');
  return true;
}
