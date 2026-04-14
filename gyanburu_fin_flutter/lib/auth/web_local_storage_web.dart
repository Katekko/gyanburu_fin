import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:web/web.dart' as web;

class WebLocalStorageKeyValueStorage implements KeyValueStorage {
  @override
  Future<String?> get(String key) async =>
      web.window.localStorage.getItem(key);

  @override
  Future<void> set(String key, String? value) async {
    if (value == null) {
      web.window.localStorage.removeItem(key);
    } else {
      web.window.localStorage.setItem(key, value);
    }
  }
}
