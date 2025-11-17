import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../services/secure_storage_service.dart';

/// Auth interceptor to add JWT token to all requests
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  final Logger _logger;

  AuthInterceptor(this._secureStorage, this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await _secureStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        _logger.d('Added auth token to request: ${options.path}');
      }
    } catch (e) {
      _logger.e('Error adding auth token', error: e);
    }
    super.onRequest(options, handler);
  }
}

/// Token refresh interceptor to handle token expiration
class TokenRefreshInterceptor extends Interceptor {
  final Dio _dio;
  final SecureStorageService _secureStorage;
  final Logger _logger;

  TokenRefreshInterceptor(this._dio, this._secureStorage, this._logger);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if error is 401 (Unauthorized)
    if (err.response?.statusCode == 401) {
      try {
        _logger.w('Token expired, attempting refresh...');

        // Get refresh token
        final refreshToken = await _secureStorage.getRefreshToken();
        if (refreshToken == null) {
          _logger.e('No refresh token available');
          return handler.next(err);
        }

        // Create a new Dio instance to avoid interceptor loop
        final tokenDio = Dio(BaseOptions(
          baseUrl: _dio.options.baseUrl,
          connectTimeout: _dio.options.connectTimeout,
          receiveTimeout: _dio.options.receiveTimeout,
        ));

        // Call refresh token endpoint
        final response = await tokenDio.post(
          '/auth/refresh',
          data: {'refresh_token': refreshToken},
        );

        if (response.statusCode == 200) {
          final newAccessToken = response.data['access_token'];
          final newRefreshToken = response.data['refresh_token'];

          // Save new tokens
          await _secureStorage.saveAccessToken(newAccessToken);
          if (newRefreshToken != null) {
            await _secureStorage.saveRefreshToken(newRefreshToken);
          }

          _logger.i('Token refreshed successfully');

          // Retry original request with new token
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newAccessToken';

          final clonedRequest = await _dio.fetch(opts);
          return handler.resolve(clonedRequest);
        }
      } catch (e) {
        _logger.e('Token refresh failed', error: e);
        // Clear tokens on refresh failure
        await _secureStorage.deleteTokens();
      }
    }

    return handler.next(err);
  }
}

/// Retry interceptor for network failures
class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final Logger _logger;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor(
    this._dio,
    this._logger, {
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only retry on connection/timeout errors
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    int retryCount = 0;
    final requestOptions = err.requestOptions;

    // Try to get retry count from extra data
    if (requestOptions.extra.containsKey('retry_count')) {
      retryCount = requestOptions.extra['retry_count'] as int;
    }

    if (retryCount >= maxRetries) {
      _logger.e('Max retry attempts reached for ${requestOptions.path}');
      return handler.next(err);
    }

    retryCount++;
    requestOptions.extra['retry_count'] = retryCount;

    _logger.w('Retrying request (${retryCount}/$maxRetries): ${requestOptions.path}');

    // Wait before retrying (exponential backoff)
    await Future.delayed(retryDelay * retryCount);

    try {
      final response = await _dio.fetch(requestOptions);
      return handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        return handler.next(e);
      }
      return handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    // Retry on connection errors and timeouts
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}

/// Connectivity interceptor to check internet connection
class ConnectivityInterceptor extends Interceptor {
  final Logger _logger;

  ConnectivityInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // You can add connectivity check here if needed
    // For now, let Dio handle connection errors
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {
      _logger.e('No internet connection or connection timeout');
      // You can emit a connectivity event here
    }
    super.onError(err, handler);
  }
}
