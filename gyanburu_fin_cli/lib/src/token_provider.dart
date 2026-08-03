import 'package:serverpod_client/serverpod_client.dart';

/// Sends the single shared secret on every request.
///
/// The server resolves it to the owner's user id — see [OwnerAuthentication]
/// on the server side.
class StaticTokenProvider implements ClientAuthKeyProvider {
  final String token;

  const StaticTokenProvider(this.token);

  // Serverpod requires a scheme prefix on the authorization header and
  // unwraps it before handing the raw token to the authentication handler.
  @override
  Future<String?> get authHeaderValue async =>
      wrapAsBearerAuthHeaderValue(token);
}
