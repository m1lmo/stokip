import 'package:dio/dio.dart';

final class DioHelper {
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
  static DioHelper instance() {
    _instance ??= DioHelper._init();
    return _instance!;
  }
}
