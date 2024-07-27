//todo

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageManager {
  StorageManager._init() {
    _secureStorage = const FlutterSecureStorage();
  }
  static StorageManager? _instance;
  static StorageManager get instance {
    _instance ??= StorageManager._init();
    return _instance!;
  }

  late final FlutterSecureStorage _secureStorage;

  Future<void> setToken(String token) => _secureStorage.write(key: 'jwt', value: token);

  Future<String?> get getToken => _secureStorage.read(key: 'jwt');
}
