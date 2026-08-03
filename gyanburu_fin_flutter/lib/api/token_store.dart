import 'package:serverpod_client/serverpod_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the single shared secret this app sends on every request.
///
/// The token can be baked in at build time with
/// `--dart-define=API_TOKEN=...` (useful for the desktop/mobile builds).
/// When it isn't, the app asks for it once and keeps it locally — see
/// [TokenGate]. Never bake it into the web build: anything compiled into the
/// bundle is readable by whoever loads the page.
class TokenStore {
  static const _prefsKey = 'gyanburu_api_token';
  static const _compiledIn = String.fromEnvironment('API_TOKEN');

  static String? _cached;

  static String? get current => _cached;

  static Future<String?> load() async {
    if (_compiledIn.isNotEmpty) {
      _cached = _compiledIn;
      return _cached;
    }
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    _cached = (stored != null && stored.isNotEmpty) ? stored : null;
    return _cached;
  }

  static Future<void> save(String token) async {
    _cached = token.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _cached!);
  }

  static Future<void> clear() async {
    _cached = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}

/// Feeds [TokenStore.current] into every client call.
class TokenAuthKeyProvider implements ClientAuthKeyProvider {
  const TokenAuthKeyProvider();

  // Serverpod requires a scheme prefix on the authorization header and
  // unwraps it before handing the raw token to the authentication handler.
  @override
  Future<String?> get authHeaderValue async {
    final token = TokenStore.current;
    return token == null ? null : wrapAsBearerAuthHeaderValue(token);
  }
}
