import 'package:serverpod/serverpod.dart';

/// Single-user authentication.
///
/// This app has exactly one user — the owner. Instead of a full identity
/// provider stack, every request carries a shared secret and is resolved to
/// the owner's fixed id, so endpoints keep using `session.authenticated`
/// exactly as before.
///
/// Both values come from `config/passwords.yaml`:
///   apiToken:     the shared secret the clients send
///   ownerUserId:  the UUID that owns every row in the database
class OwnerAuthentication {
  static const _tokenKey = 'apiToken';
  static const _ownerKey = 'ownerUserId';

  /// The authentication key id reported for the owner's session.
  static const authId = 'owner';

  static Future<AuthenticationInfo?> handler(
    Session session,
    String token,
  ) async {
    final expectedToken = session.passwords[_tokenKey];
    final ownerUserId = session.passwords[_ownerKey];

    if (expectedToken == null || expectedToken.isEmpty) {
      session.log(
        '[Auth] "$_tokenKey" is not set in passwords.yaml — refusing all '
        'requests. Set it and restart the server.',
        level: LogLevel.error,
      );
      return null;
    }
    if (ownerUserId == null || ownerUserId.isEmpty) {
      session.log(
        '[Auth] "$_ownerKey" is not set in passwords.yaml — refusing all '
        'requests. Set it and restart the server.',
        level: LogLevel.error,
      );
      return null;
    }

    if (!_secureEquals(token, expectedToken)) return null;

    return AuthenticationInfo(ownerUserId, const {}, authId: authId);
  }

  /// Compares in time proportional to the input length only, so a wrong token
  /// can't be recovered one character at a time by timing the responses.
  static bool _secureEquals(String a, String b) {
    final aBytes = a.codeUnits;
    final bBytes = b.codeUnits;
    var diff = aBytes.length ^ bBytes.length;
    for (var i = 0; i < aBytes.length; i++) {
      diff |= aBytes[i] ^ bBytes[i % (bBytes.isEmpty ? 1 : bBytes.length)];
    }
    return diff == 0;
  }
}
