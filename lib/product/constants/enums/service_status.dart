import 'dart:io';

import 'package:stokip/product/helper/failure.dart';

enum ServiceStatus {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTHORIZED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  NO_INTERNET_CONNECTION,
}

extension ServiceStatusExtension on ServiceStatus {
  Failure getFailure() {
    switch (this) {
      case ServiceStatus.SUCCESS:
        return Failure(HttpStatus.ok, 'SUCCESS');
      case ServiceStatus.NO_CONTENT:
        return Failure(HttpStatus.noContent, 'NO CONTENT');
      case ServiceStatus.BAD_REQUEST:
        return Failure(HttpStatus.badRequest, 'BAD REQUEST');
      case ServiceStatus.FORBIDDEN:
        return Failure(HttpStatus.forbidden, 'FORBIDDEN');
      case ServiceStatus.UNAUTHORIZED:
        return Failure(HttpStatus.unauthorized, 'UNAUTHORIZED');
      case ServiceStatus.NOT_FOUND:
        return Failure(HttpStatus.notFound, 'NOT FOUND');
      case ServiceStatus.INTERNAL_SERVER_ERROR:
        return Failure(HttpStatus.internalServerError, 'SERVER ERROR');
      case ServiceStatus.CONNECT_TIMEOUT:
        return Failure(
          HttpStatus.gatewayTimeout,
          'Connection Timeout',
        );
      case ServiceStatus.NO_INTERNET_CONNECTION:
        return Failure(
          HttpStatus.serviceUnavailable,
          'No Internet Connection',
        );
    }
  }
}
