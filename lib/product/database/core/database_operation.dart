import 'package:stokip/product/database/core/model/hive_model2_mixin.dart';

import 'package:stokip/product/database/core/hive_manager_mixin.dart';

class HiveDataBaseOperation<T extends HiveModel2Mixin> with HiveManagerMixin<T> {
  /// The `clear` function clears all data in the `box`.
  Future<void> clear() => box.clear();
  void remove(T model) {
    box.delete(model.key);
  }

  void removeTemp(T model) {
    box.delete('temp${model.key}');
  }

  /// The function adds or updates an item in a box using a key-value pair.
  ///
  /// Args:
  ///   model (T): The parameter "model" is of type T, which means it can be any type. It represents the
  /// item that needs to be added or updated in the "box". The "box" is not defined in the code snippet,
  /// but it is likely a reference to some kind of data storage or database
  Future<void> addOrUpdateItem(T model) => box.put(model.key, model);
  Future<void> addItemTemporary(T model) => box.put('temp${model.key}', model);

  /// The `getItems` function is retrieving an item from the `box` based on the provided `key`. It takes a
  /// `String` parameter `key` and uses it to retrieve the corresponding item from the `box` using the
  /// `get` method. The retrieved item is not returned or used in any way in the provided code snippet.
  T? getItems(String key) => box.get(key);
  T? getItemsTemporary(String key) => box.get('temp$key');
}
