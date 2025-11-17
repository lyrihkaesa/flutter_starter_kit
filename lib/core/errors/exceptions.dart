class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException(this.message, [this.statusCode]);

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);

  @override
  String toString() => 'AuthenticationException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;

  ValidationException(this.message, [this.errors]);

  @override
  String toString() => 'ValidationException: $message';
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);

  @override
  String toString() => 'UnauthorizedException: $message';
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);

  @override
  String toString() => 'NotFoundException: $message';
}

class BlockchainException implements Exception {
  final String message;

  BlockchainException(this.message);

  @override
  String toString() => 'BlockchainException: $message';
}

class WalletException implements Exception {
  final String message;

  WalletException(this.message);

  @override
  String toString() => 'WalletException: $message';
}

class InsufficientBalanceException implements Exception {
  final String message;
  final double required;
  final double available;

  InsufficientBalanceException(
    this.message, {
    required this.required,
    required this.available,
  });

  @override
  String toString() =>
      'InsufficientBalanceException: $message (Required: $required, Available: $available)';
}
