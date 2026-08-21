import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/exception.dart';
import '../../models/auth_response_model.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
    String? deviceName,
  });

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? deviceName,
  });

  Future<UserModel> getMe();

  Future<void> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
    String? deviceName,
  }) async {
    try {
      final response = await _dio.post(
        '/v1/login',
        data: {
          'email': email,
          'password': password,
          'device_name': ?deviceName,
        },
      );

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? deviceName,
  }) async {
    try {
      final response = await _dio.post(
        '/v1/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'device_name': ?deviceName,
        },
      );

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await _dio.get('/v1/me');
      final dataMap = response.data['data'] as Map<String, dynamic>;
      return UserModel.fromJson(dataMap);
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post('/v1/logout');
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Never _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw const ConnectionException(message: 'Tidak dapat terhubung ke server');
    }

    final response = e.response;
    if (response != null) {
      final statusCode = response.statusCode;
      final responseData = response.data;

      if (statusCode == 422 && responseData is Map<String, dynamic>) {
        final rawErrors = responseData['errors'];
        final Map<String, List<String>> parsedErrors = {};

        if (rawErrors is Map<String, dynamic>) {
          rawErrors.forEach((key, value) {
            if (value is List) {
              parsedErrors[key] = value.map((e) => e.toString()).toList();
            }
          });
        }

        final message = responseData['message']?.toString() ?? 'Validasi gagal';
        throw ValidationException(parsedErrors, message: message);
      }

      if (statusCode == 401) {
        final message = (responseData is Map && responseData['message'] != null)
            ? responseData['message'].toString()
            : 'Kredensial tidak valid atau belum terautentikasi';
        throw UnauthorizedException(message: message);
      }

      final message = (responseData is Map && responseData['message'] != null)
          ? responseData['message'].toString()
          : 'Terjadi kesalahan pada server ($statusCode)';
      throw ServerException(message: message);
    }

    throw ServerException(message: e.message ?? 'Terjadi kesalahan jaringan');
  }
}
