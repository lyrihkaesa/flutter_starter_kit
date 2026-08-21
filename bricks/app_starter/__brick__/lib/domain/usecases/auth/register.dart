import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failure.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

@lazySingleton
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<Failure, User>> call({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? deviceName,
  }) {
    return _repository.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      deviceName: deviceName,
    );
  }
}
