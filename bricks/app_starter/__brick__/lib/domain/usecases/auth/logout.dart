import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failure.dart';
import '../../repositories/auth_repository.dart';

@lazySingleton
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.logout();
  }
}
