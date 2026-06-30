// Cross-platform "copy text to the clipboard".
//
// On native platforms this is just Flutter's Clipboard. On the web Flutter's
// `Clipboard.setData` silently fails in several common situations (the page is
// served over plain http / a LAN IP, so `navigator.clipboard` is unavailable),
// so the web implementation uses the legacy `execCommand('copy')` path that
// works in any browser context as long as it runs inside a user gesture.
export 'clipboard_helper_stub.dart'
    if (dart.library.js_interop) 'clipboard_helper_web.dart';
