import 'dart:io';

import 'package:dio/dio.dart';
import 'package:stokip/feature/service/model/service_model.dart';
import 'package:stokip/feature/service/manager/service_manager.dart';
import 'package:stokip/product/helper/error_handler.dart';

/// Base class for repository
/// extend the class with [ServiceModel] to use the repository
abstract class IRepository<T extends ServiceModel> extends ServiceManager<T> {
  Future<bool> postData(T data) async {
    final response = await dio.post<Map<String, dynamic>>(path, data: data.toJson());
    print(response.data);
    return response.statusCode == HttpStatus.created;
  }

  Future<List<T?>?> fetchData() async {
    final response = await dio.get<List<dynamic>>(path);
    if (response.statusCode != HttpStatus.ok) return null;
    final datas = response.data;
    if (datas is List) {
      if (datas.isEmpty ?? true) return null;
      return datas.whereType<Map<String, dynamic>>().map((e) => fromJson(e)).toList(); // Replace whereTypeOrNull with whereType
    }
    return null;
  }

  Future<Response<Map<String, dynamic>>?> postWithResponse(T data) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(path, data: data.toJson());
      return response;
    } on DioException catch (e) {
      print(ErrorHandler.handler(e).failure);
      return null;
    }
  }
}
