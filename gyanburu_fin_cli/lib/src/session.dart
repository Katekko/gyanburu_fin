import 'dart:io';

import 'package:gyanburu_fin_client/gyanburu_fin_client.dart';

import 'token_provider.dart';

/// Default production server. Override with --server or GYANBURU_SERVER.
const defaultServerUrl = 'http://192.168.0.229:8080/';

String defaultTokenPath() {
  final home = Platform.environment['HOME'] ??
      Platform.environment['USERPROFILE'] ??
      '.';
  return '$home/.config/gyanburu/token';
}

/// Reads the shared secret, preferring the environment so CI and scripts can
/// pass it without touching the filesystem.
String? readToken({String? tokenPath}) {
  final fromEnv = Platform.environment['GYANBURU_TOKEN'];
  if (fromEnv != null && fromEnv.trim().isNotEmpty) return fromEnv.trim();

  final file = File(tokenPath ?? defaultTokenPath());
  if (!file.existsSync()) return null;
  final contents = file.readAsStringSync().trim();
  return contents.isEmpty ? null : contents;
}

void writeToken(String token, {String? tokenPath}) {
  final file = File(tokenPath ?? defaultTokenPath());
  file.parent.createSync(recursive: true);
  file.writeAsStringSync('${token.trim()}\n');
  if (!Platform.isWindows) {
    Process.runSync('chmod', ['600', file.path]);
  }
}

/// Builds a client that sends the shared secret on every call.
Client buildClient({String? serverUrl, String? tokenPath}) {
  final url = serverUrl ??
      Platform.environment['GYANBURU_SERVER'] ??
      defaultServerUrl;

  final client = Client(url);
  final token = readToken(tokenPath: tokenPath);
  if (token != null) {
    client.authKeyProvider = StaticTokenProvider(token);
  }
  return client;
}

/// Reads a secret from the terminal without echoing it back.
String promptHidden(String label) {
  stdout.write('$label: ');
  final wasEchoing = stdin.echoMode;
  try {
    stdin.echoMode = false;
    return stdin.readLineSync() ?? '';
  } finally {
    stdin.echoMode = wasEchoing;
    stdout.writeln();
  }
}
