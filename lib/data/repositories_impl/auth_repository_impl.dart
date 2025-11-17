import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/exception.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_data_source.dart';
import '../datasources/remote/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, ({AuthToken token, User user})>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save tokens and user locally
      await _localDataSource.saveTokens(
        result.token.accessToken,
        result.token.refreshToken,
      );
      await _localDataSource.saveUser(result.user);

      return Right((
        token: result.token.toEntity(),
        user: result.user.toEntity(),
      ));
    } on ValidationException catch (e) {
      return Left(Failure.validation(e.errors, message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(Failure.unauthorized(
        message: e.message,
        error: e.error,
        errorDescription: e.errorDescription,
      ));
    } on ConnectionException catch (e) {
      return Left(Failure.connection(message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.server(
        message: e.message,
        error: e.error,
        errorDescription: e.errorDescription,
      ));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ({AuthToken token, User user})>> register({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    try {
      final result = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );

      // Save tokens and user locally
      await _localDataSource.saveTokens(
        result.token.accessToken,
        result.token.refreshToken,
      );
      await _localDataSource.saveUser(result.user);

      return Right((
        token: result.token.toEntity(),
        user: result.user.toEntity(),
      ));
    } on ValidationException catch (e) {
      return Left(Failure.validation(e.errors, message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(Failure.unauthorized(
        message: e.message,
        error: e.error,
        errorDescription: e.errorDescription,
      ));
    } on ConnectionException catch (e) {
      return Left(Failure.connection(message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.server(
        message: e.message,
        error: e.error,
        errorDescription: e.errorDescription,
      ));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.deleteTokens();
      await _localDataSource.deleteUser();
      return const Right(null);
    } on ServerException catch (e) {
      // Even if server logout fails, clear local data
      await _localDataSource.deleteTokens();
      await _localDataSource.deleteUser();
      return Left(Failure.server(
        message: e.message,
        error: e.error,
        errorDescription: e.errorDescription,
      ));
    } catch (e) {
      // Clear local data on any error
      await _localDataSource.deleteTokens();
      await _localDataSource.deleteUser();
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Try to get from local first
      final localUser = await _localDataSource.getUser();
      if (localUser != null) {
        return Right(localUser.toEntity());
      }

      // If not found locally, fetch from remote
      final remoteUser = await _remoteDataSource.getCurrentUser();
      await _localDataSource.saveUser(remoteUser);

      return Right(remoteUser.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(Failure.unauthorized(
        message: e.message,
        error: e.error,
        errorDescription: e.errorDescription,
      ));
    } on ConnectionException catch (e) {
      return Left(Failure.connection(message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.server(
        message: e.message,
        error: e.error,
        errorDescription: e.errorDescription,
      ));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthToken>> refreshToken(String refreshToken) async {
    try {
      final tokenModel = await _remoteDataSource.refreshToken(refreshToken);

      // Save new tokens
      await _localDataSource.saveTokens(
        tokenModel.accessToken,
        tokenModel.refreshToken,
      );

      return Right(tokenModel.toEntity());
    } on UnauthorizedException catch (e) {
      // Clear local data if refresh fails
      await _localDataSource.deleteTokens();
      await _localDataSource.deleteUser();

      return Left(Failure.tokenExpired(
        message: e.message,
        error: e.error,
        errorDescription: e.errorDescription,
      ));
    } on ConnectionException catch (e) {
      return Left(Failure.connection(message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.server(
        message: e.message,
        error: e.error,
        errorDescription: e.errorDescription,
      ));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _localDataSource.isLoggedIn();
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String code) async {
    try {
      await _remoteDataSource.verifyEmail(code);
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(Failure.validation(e.errors, message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.server(
        message: e.message,
        error: e.error,
        errorDescription: e.errorDescription,
      ));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(email);
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(Failure.validation(e.errors, message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.server(
        message: e.message,
        error: e.error,
        errorDescription: e.errorDescription,
      ));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(Failure.validation(e.errors, message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.server(
        message: e.message,
        error: e.error,
        errorDescription: e.errorDescription,
      ));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phone,
    String? avatar,
  }) async {
    try {
      final updatedUser = await _remoteDataSource.updateProfile(
        name: name,
        phone: phone,
        avatar: avatar,
      );

      // Update local user data
      await _localDataSource.saveUser(updatedUser);

      return Right(updatedUser.toEntity());
    } on ValidationException catch (e) {
      return Left(Failure.validation(e.errors, message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.server(
        message: e.message,
        error: e.error,
        errorDescription: e.errorDescription,
      ));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
