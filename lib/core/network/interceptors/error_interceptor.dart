import 'package:dio/dio.dart';
import '../../errors/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException('Connection timeout. Please check your internet connection.');

      case DioExceptionType.badResponse:
        _handleStatusCode(err.response?.statusCode, err.response?.data);
        break;

      case DioExceptionType.cancel:
        throw NetworkException('Request cancelled');

      case DioExceptionType.unknown:
        throw NetworkException('No internet connection');

      default:
        throw NetworkException('Unexpected error occurred');
    }

    return handler.next(err);
  }

  void _handleStatusCode(int? statusCode, dynamic data) {
    final message = _extractErrorMessage(data);

    switch (statusCode) {
      case 400:
        throw ValidationException(message ?? 'Bad request');

      case 401:
        throw AuthenticationException(message ?? 'Unauthorized');

      case 403:
        throw UnauthorizedException(message ?? 'Access forbidden');

      case 404:
        throw NotFoundException(message ?? 'Resource not found');

      case 422:
        throw ValidationException(
          message ?? 'Validation failed',
          data is Map ? data['errors'] : null,
        );

      case 500:
      case 502:
      case 503:
        throw ServerException(message ?? 'Server error', statusCode);

      default:
        throw ServerException(message ?? 'Unknown error', statusCode);
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map) {
      return data['message'] ?? data['error'] ?? data['msg'];
    }

    if (data is String) {
      return data;
    }

    return null;
  }
}
