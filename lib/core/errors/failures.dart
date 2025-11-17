import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

// Server Failures
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Network Failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

// Cache Failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Authentication Failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

// Validation Failures
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

// Not Found Failures
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

// Unauthorized Failures
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

// Blockchain/TRON Failures
class BlockchainFailure extends Failure {
  const BlockchainFailure(super.message);
}

// Wallet Failures
class WalletFailure extends Failure {
  const WalletFailure(super.message);
}

// Insufficient Balance
class InsufficientBalanceFailure extends Failure {
  const InsufficientBalanceFailure(super.message);
}

// Unknown Failures
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
