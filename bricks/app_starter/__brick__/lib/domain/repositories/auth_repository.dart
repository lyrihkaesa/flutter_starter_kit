import 'package:fpdart/fpdart.dart';

import '../../core/errors/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
    String? deviceName,
  });

  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? deviceName,
  });

  Future<Either<Failure, User>> getMe();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, String?>> getSavedToken();
}
