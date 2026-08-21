import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/exception.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/user.dart';
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
    try {
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
        return Right(authResponse.data!.user!.toEntity());
      }

      final userModel = await _remoteDataSource.getMe();
      return Right(userModel.toEntity());
    } on ValidationException catch (e) {
      return Left(Failure.validation(e.errors, message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(Failure.unauthorized(message: e.message));
    } on ConnectionException catch (e) {
      return Left(Failure.connection(message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? deviceName,
  }) async {
    try {
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
        return Right(authResponse.data!.user!.toEntity());
      }

      final userModel = await _remoteDataSource.getMe();
      return Right(userModel.toEntity());
    } on ValidationException catch (e) {
      return Left(Failure.validation(e.errors, message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(Failure.unauthorized(message: e.message));
    } on ConnectionException catch (e) {
      return Left(Failure.connection(message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getMe() async {
    try {
      final userModel = await _remoteDataSource.getMe();
      return Right(userModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(Failure.unauthorized(message: e.message));
    } on ConnectionException catch (e) {
      return Left(Failure.connection(message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
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
    try {
      final token = await _localDataSource.getToken();
      return Right(token);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
