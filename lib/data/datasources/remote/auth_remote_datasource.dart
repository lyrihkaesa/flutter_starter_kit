import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../models/responses/auth_response_model.dart';
import '../../models/responses/user_model.dart';

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

  Future<UserModel> updateProfile({
    String? name,
    String? locale,
    String? timezone,
    String? theme,
  });

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
    final response = await _dio.post(
      '/v1/login',
      data: {
        'email': email,
        'password': password,
        'device_name': ?deviceName,
      },
    );

    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? deviceName,
  }) async {
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
  }

  @override
  Future<UserModel> getMe() async {
    final response = await _dio.get('/v1/me');
    final dataMap = response.data['data'] as Map<String, dynamic>;
    return UserModel.fromJson(dataMap);
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? locale,
    String? timezone,
    String? theme,
  }) async {
    final response = await _dio.patch(
      '/v1/me',
      data: {
        'name': ?name,
        'locale': ?locale,
        'timezone': ?timezone,
        'theme': ?theme,
      },
    );

    final dataMap = response.data['data'] as Map<String, dynamic>;
    return UserModel.fromJson(dataMap);
  }

  @override
  Future<void> logout() async {
    await _dio.post('/v1/logout');
  }
}
