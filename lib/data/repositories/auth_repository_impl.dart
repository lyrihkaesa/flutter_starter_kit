import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/exception.dart';
import '../../core/errors/failure.dart';
import '../../core/utils/error_handler.dart';
import '../../domain/entities/responses/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
    String? deviceName,
  }) async {
    return safeRepositoryCall(() async {
      final authResponse = await _remoteDataSource.login(
        email: email,
        password: password,
        deviceName: deviceName,
      );

      final token = authResponse.data?.token ?? authResponse.data?.accessToken;
      if (token != null && token.isNotEmpty) {
        await _localDataSource.saveToken(token);
      }

      if (authResponse.data?.user != null) {
        return authResponse.data!.user!.toEntity();
      }

      final userModel = await _remoteDataSource.getMe();
      return userModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? deviceName,
  }) async {
    return safeRepositoryCall(() async {
      final authResponse = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        deviceName: deviceName,
      );

      final token = authResponse.data?.token ?? authResponse.data?.accessToken;
      if (token != null && token.isNotEmpty) {
        await _localDataSource.saveToken(token);
      }

      if (authResponse.data?.user != null) {
        return authResponse.data!.user!.toEntity();
      }

      final userModel = await _remoteDataSource.getMe();
      return userModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, User>> getMe() async {
    return safeRepositoryCall(() async {
      final userModel = await _remoteDataSource.getMe();
      return userModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (_) {
      // Abaikan error jaringan saat logout agar token lokal tetap terhapus
    } finally {
      try {
        await _localDataSource.deleteToken();
      } on CacheException catch (e) {
        return Left(Failure.cache(message: e.message));
      }
    }
    return const Right(null);
  }

  @override
  Future<Either<Failure, String?>> getSavedToken() async {
    return safeRepositoryCall(() async {
      return await _localDataSource.getToken();
    });
  }
}
