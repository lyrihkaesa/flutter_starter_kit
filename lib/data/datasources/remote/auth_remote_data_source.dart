import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/exception.dart';
import '../../models/auth_token_model.dart';
import '../../models/response_model.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<({AuthTokenModel token, UserModel user})> login({
    required String email,
    required String password,
  });

  Future<({AuthTokenModel token, UserModel user})> register({
    required String email,
    required String password,
    String? name,
    String? phone,
  });

  Future<void> logout();

  Future<UserModel> getCurrentUser();

  Future<AuthTokenModel> refreshToken(String refreshToken);

  Future<void> verifyEmail(String code);

  Future<void> forgotPassword(String email);

  Future<void> resetPassword({required String token, required String newPassword});

  Future<UserModel> updateProfile({String? name, String? phone, String? avatar});
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<({AuthTokenModel token, UserModel user})> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Parse response based on your API structure
        final tokenModel = AuthTokenModel.fromJson(data['token'] ?? data);
        final userModel = UserModel.fromJson(data['user'] ?? data['data']);

        return (token: tokenModel, user: userModel);
      }

      throw ServerException(message: 'Login failed');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<({AuthTokenModel token, UserModel user})> register({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final tokenModel = AuthTokenModel.fromJson(data['token'] ?? data);
        final userModel = UserModel.fromJson(data['user'] ?? data['data']);

        return (token: tokenModel, user: userModel);
      }

      throw ServerException(message: 'Registration failed');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post('/auth/logout');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get('/auth/me');

      if (response.statusCode == 200) {
        final responseModel = ResponseModel<Map<String, dynamic>>.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );

        if (responseModel.data != null) {
          return UserModel.fromJson(responseModel.data!);
        }
      }

      throw ServerException(message: 'Failed to get user');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<AuthTokenModel> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        return AuthTokenModel.fromJson(response.data);
      }

      throw ServerException(message: 'Token refresh failed');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> verifyEmail(String code) async {
    try {
      await dio.post(
        '/auth/verify-email',
        data: {'code': code},
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({required String token, required String newPassword}) async {
    try {
      await dio.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'password': newPassword,
        },
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<UserModel> updateProfile({String? name, String? phone, String? avatar}) async {
    try {
      final response = await dio.put(
        '/auth/profile',
        data: {
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
          if (avatar != null) 'avatar': avatar,
        },
      );

      if (response.statusCode == 200) {
        final responseModel = ResponseModel<Map<String, dynamic>>.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );

        if (responseModel.data != null) {
          return UserModel.fromJson(responseModel.data!);
        }
      }

      throw ServerException(message: 'Failed to update profile');
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  // Error handling helper
  void _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      // Parse error from response
      final responseModel = ResponseModel<dynamic>.fromJson(data, (json) => json);

      // Validation errors (422)
      if (statusCode == 422 && responseModel.errors != null) {
        throw ValidationException(
          responseModel.errors!,
          message: responseModel.message,
        );
      }

      // Unauthorized (401)
      if (statusCode == 401) {
        throw UnauthorizedException(
          message: responseModel.message,
          error: responseModel.error,
          errorDescription: responseModel.errorDescription,
        );
      }

      // Server errors (5xx)
      if (statusCode != null && statusCode >= 500) {
        throw ServerException(
          message: responseModel.message ?? 'Server error',
          error: responseModel.error,
          errorDescription: responseModel.errorDescription,
        );
      }

      // Other errors
      throw ServerException(
        message: responseModel.message ?? 'An error occurred',
        error: responseModel.error,
        errorDescription: responseModel.errorDescription,
      );
    }

    // Network errors
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      throw const ConnectionException(message: 'Network error. Please check your connection.');
    }

    // Unknown errors
    throw UnknownException(message: error.message);
  }
}
