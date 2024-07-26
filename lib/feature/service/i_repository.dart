import 'dart:io';

import 'package:dio/dio.dart';
import 'package:stokip/feature/model/user_model.dart';
import 'package:stokip/feature/service/manager/service_manager.dart';
import 'package:stokip/feature/service/model/service_model.dart';
import 'package:stokip/product/helper/error_handler.dart';
import 'package:stokip/product/widgets/c_notify.dart';

/// Base class for repository
/// extend the class with [ServiceModel] to use the repository
abstract class IRepository<T extends ServiceModel> extends ServiceManager<T> {
  Future<bool> postData(T data) async {
    try {
      print(data.toJson());
      final response = await dio.post<Map<String, dynamic>>(path, data: data.toJson());
      return response.statusCode == HttpStatus.created;
    } on DioException catch (e) {
      final failure = ErrorHandler.handler(e).failure;
      CNotify(
        title: 'Hata',
        message: failure.message,
      ).show();
      return false;
    }
  }

  Future<List<T?>?> fetchData() async {
    try {
      final response = await dio.get<List<dynamic>>(path);
      if (response.statusCode != HttpStatus.ok) return null;
      final datas = response.data;
      if (datas is List) {
        if (datas.isEmpty) return null;
        return datas.whereType<Map<String, dynamic>>().map((e) => fromJson(e)).toList(); // Replace whereTypeOrNull with whereType
      }
      return null;
    } on DioException catch (e) {
      final failure = ErrorHandler.handler(e).failure;
      CNotify(
        title: 'Hata',
        message: failure.message,
      ).show();
      return null;
    }
  }

  Future<T?> postWithResponse(T data) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(path, data: data.toJson());
      final responseData = response.data;
      if (response.statusCode != HttpStatus.ok) return null;
      if (responseData is Map<String, dynamic>) {
        return fromJson(responseData);
      }
    } on DioException catch (e) {
      final failure = ErrorHandler.handler(e).failure;
      CNotify(
        title: 'Hata',
        message: failure.message,
      ).show();
      return null;
    }
    return null;
  }

  Future<UserModel> postToken() async {
    final response = await dio.post<Map<String, dynamic>>(path);
    final responseData = response.data;
    if (response.statusCode != HttpStatus.ok) return UserModel();
    if (responseData is Map<String, dynamic>) {
      return UserModel.fromJson(responseData);
    }
    return UserModel();
  }
}
