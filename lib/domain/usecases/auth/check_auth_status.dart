import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failure.dart';
import '../../repositories/auth_repository.dart';

@lazySingleton
class CheckAuthStatusUseCase {
  final AuthRepository _repository;

  CheckAuthStatusUseCase(this._repository);

  Future<Either<Failure, String?>> call() {
    return _repository.getSavedToken();
  }
}
