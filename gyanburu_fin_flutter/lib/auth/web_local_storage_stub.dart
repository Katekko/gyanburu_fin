import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class WebLocalStorageKeyValueStorage implements KeyValueStorage {
  @override
  Future<String?> get(String key) =>
      throw UnsupportedError('WebLocalStorageKeyValueStorage is web-only.');

  @override
  Future<void> set(String key, String? value) =>
      throw UnsupportedError('WebLocalStorageKeyValueStorage is web-only.');
}
