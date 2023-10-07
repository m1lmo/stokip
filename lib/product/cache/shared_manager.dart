import 'package:shared_preferences/shared_preferences.dart';

class SharedManager {
  late final SharedPreferences prefs;
  SharedManager();
  static SharedManager? instance;
  SharedManager._singleton() {}

  static Future<SharedManager> get getInstance async {
    if (instance == null) {
      instance = SharedManager._singleton();
      await instance!.init();
    }
    return instance!;
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> writeId(int id, String key) async {
    await prefs.setInt(key, id);
  }

  int? readId(String key) {
    return prefs.getInt(key);
  }
}
