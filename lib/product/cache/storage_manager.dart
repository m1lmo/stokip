//todo

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageManager {
  StorageManager._init() {
    _secureStorage = const FlutterSecureStorage();
  }
  factory StorageManager.instance() {
    _instance ??= StorageManager._init();
    return _instance!;
  }
  static StorageManager? _instance;

  late final FlutterSecureStorage _secureStorage;

  Future<void> writeToken(String token) => _secureStorage.write(key: 'jwt', value: token);

  Future<String?> get getToken => _secureStorage.read(key: 'jwt');
}
