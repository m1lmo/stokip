import 'package:dio/dio.dart';
import 'package:stokip/product/constants/enums/service_status.dart';
import 'package:stokip/product/helper/failure.dart';

final class ErrorHandler implements Exception {
  ErrorHandler.handler(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    }
  }
  late Failure failure;
  Failure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ServiceStatus.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.sendTimeout:
        return ServiceStatus.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.receiveTimeout:
        return ServiceStatus.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.badResponse:
        if (error.response != null && error.response?.statusCode != null) {
          return Failure(error.response!.statusCode!, error.response!.data['message'].toString());
        }
      default:
        return Failure(error.response!.statusCode!, 'Unknown Error');
    }
    return ServiceStatus.INTERNAL_SERVER_ERROR.getFailure();
  }
}
