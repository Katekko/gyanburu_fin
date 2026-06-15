import 'dart:typed_data';

/// Non-web fallback. In-app image preview is handled separately; opening other
/// file types in a browser tab is only available on the web build.
bool openBytesInNewTab(Uint8List bytes, String contentType, String fileName) =>
    false;
