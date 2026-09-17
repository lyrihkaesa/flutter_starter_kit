import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../models/responses/response_model.dart';
import '../../models/responses/user_model.dart';

abstract class UserRemoteDataSource {
  Future<ResponseModel<List<UserModel>>> getUsers({
    int? page,
    int? perPage,
    String? pagination,
  });

  Future<UserModel> createUser({
    required String name,
    required String email,
    required String password,
    List<String>? roles,
  });

  Future<UserModel> getUserById(String id);

  Future<UserModel> updateUser({
    required String id,
    String? name,
    String? email,
    String? password,
    List<String>? roles,
  });

  Future<void> deleteUser(String id);
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSourceImpl(this._dio);

  @override
  Future<ResponseModel<List<UserModel>>> getUsers({
    int? page,
    int? perPage,
    String? pagination,
  }) async {
    final response = await _dio.get(
      '/v1/users',
      queryParameters: {
        'page': ?page,
        'per_page': ?perPage,
        'pagination': ?pagination,
      },
    );

    return ResponseModel.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<UserModel> createUser({
    required String name,
    required String email,
    required String password,
    List<String>? roles,
  }) async {
    final response = await _dio.post(
      '/v1/users',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'roles': ?roles,
      },
    );

    final dataMap = response.data['data'] as Map<String, dynamic>;
    return UserModel.fromJson(dataMap);
  }

  @override
  Future<UserModel> getUserById(String id) async {
    final response = await _dio.get('/v1/users/$id');
    final dataMap = response.data['data'] as Map<String, dynamic>;
    return UserModel.fromJson(dataMap);
  }

  @override
  Future<UserModel> updateUser({
    required String id,
    String? name,
    String? email,
    String? password,
    List<String>? roles,
  }) async {
    final response = await _dio.put(
      '/v1/users/$id',
      data: {
        'name': ?name,
        'email': ?email,
        'password': ?password,
        'roles': ?roles,
      },
    );

    final dataMap = response.data['data'] as Map<String, dynamic>;
    return UserModel.fromJson(dataMap);
  }

  @override
  Future<void> deleteUser(String id) async {
    await _dio.delete('/v1/users/$id');
  }
}
