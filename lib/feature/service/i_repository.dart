import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:stokip/feature/service/model/service_model.dart';
import 'package:stokip/feature/service/manager/service_manager.dart';

/// Base class for repository
/// extend the class with [ServiceModel] to use the repository
abstract class IRepository<T extends ServiceModel> extends ServiceManager<T> {
  Future<bool> postData(T data) async {
    final response = await dio.post<T>(path, data: data.toJson());
    return response.statusCode == HttpStatus.created;
  }

  Future<List<T>?> fetchData() async {
    final response = await dio.get<Map<String, dynamic>>(path).call();
    if (response.statusCode != HttpStatus.ok) return null;
    final datas = response.data;
    if (datas is List) {
      return datas.whereType<Map<String, dynamic>>().map((e) => fromJson(e)).toList();
    }
    return null;
  }
}
