import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<Either<Failure, AuthResponse>> call({
    required String email,
    required String password,
    required String name,
    String? referralCode,
  }) async {
    return await repository.register(
      email: email,
      password: password,
      name: name,
      referralCode: referralCode,
    );
  }
}
