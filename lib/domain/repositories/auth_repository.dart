import 'package:fpdart/fpdart.dart';

import '../../core/errors/failure.dart';
import '../entities/auth_token.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, ({AuthToken token, User user})>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<Either<Failure, ({AuthToken token, User user})>> register({
    required String email,
    required String password,
    String? name,
    String? phone,
  });

  /// Logout
  Future<Either<Failure, void>> logout();

  /// Get current user
  Future<Either<Failure, User>> getCurrentUser();

  /// Refresh access token
  Future<Either<Failure, AuthToken>> refreshToken(String refreshToken);

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Verify email
  Future<Either<Failure, void>> verifyEmail(String code);

  /// Request password reset
  Future<Either<Failure, void>> forgotPassword(String email);

  /// Reset password
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phone,
    String? avatar,
  });
}
