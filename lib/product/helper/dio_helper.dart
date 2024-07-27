import 'package:dio/dio.dart';

final class DioHelper {
  factory DioHelper.instance() {
    _instance ??= DioHelper._init();
    return _instance!;
  }
  DioHelper._init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:8080',
        receiveDataWhenStatusError: true,
        headers: Map<String, dynamic>.from({
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
        }),
      ),
    );
  }

  late final Dio dio;
  static DioHelper? _instance;

  /// Set token to header
  /// u have to set this token before any request
  //! DONT FORGET TO SET TOKEN
  void setToken(String? token) {
    if (token?.isEmpty ?? true) return;
    if (dio.options.headers.containsKey('Authorization')) {
      dio.options.headers.remove('Authorization');
    }
    dio.options.headers['Authorization'] = token;
  }
}
