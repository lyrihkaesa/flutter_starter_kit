import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failure.dart';
import '../../entities/responses/user.dart';

import '../../repositories/auth_repository.dart';

@lazySingleton
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    String? deviceName,
  }) {
    return _repository.login(
      email: email,
      password: password,
      deviceName: deviceName,
    );
  }
}
