import 'package:hive_flutter/adapters.dart';

mixin HiveManagerMixin<T> {
  final String _key = T.toString();

  late Box<T> box;
  Future<void> start() async {
    box = await Hive.openBox<T>(_key);
  }
}
