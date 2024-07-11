import 'package:dio/dio.dart';
import 'package:stokip/feature/service/model/service_model.dart';

abstract mixin class ServiceManager<T extends ServiceModel> {
  Dio get dio;
  String get path;
  T Function(Map<String, dynamic> json) get fromJson;
  String baseUrl = 'https://192.168.1.110:7133/api';
}
