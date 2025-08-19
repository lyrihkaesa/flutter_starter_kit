/// Base Exception class
abstract class AppException implements Exception {
  final String? message; // pesan umum
  final String? error; // kode error (misalnya: invalid_grant, token_expired)
  final String? errorDescription; // deskripsi error dari API

  const AppException({this.message, this.error, this.errorDescription});

  @override
  String toString() {
    final details = [
      if (error != null) "error=$error",
      if (errorDescription != null) "desc=$errorDescription",
      if (message != null) "msg=$message",
    ].join(", ");
    return "$runtimeType($details)";
  }
}

/// Thrown when server returns 5xx or unexpected response
class ServerException extends AppException {
  const ServerException({String? message, String? error, String? errorDescription})
    : super(message: message, error: error, errorDescription: errorDescription);
}

/// Thrown when validation errors (Laravel style)
class ValidationException extends AppException {
  final Map<String, List<String>> errors;

  const ValidationException(this.errors, {String? message}) : super(message: message);

  @override
  String toString() => "ValidationException(errors=$errors, msg=$message)";
}

/// Thrown when unauthorized or invalid token (OAuth2/JWT)
class UnauthorizedException extends AppException {
  const UnauthorizedException({String? message, String? error, String? errorDescription})
    : super(message: message, error: error, errorDescription: errorDescription);
}

/// Thrown when token is expired
class TokenExpiredException extends AppException {
  const TokenExpiredException({String? message, String? error, String? errorDescription})
    : super(message: message, error: error, errorDescription: errorDescription);
}

/// Thrown when no internet or timeout
class ConnectionException extends AppException {
  const ConnectionException({String? message}) : super(message: message);
}

/// Thrown when local database (SQLite/Hive) fails
class DatabaseException extends AppException {
  const DatabaseException({String? message}) : super(message: message);
}

/// Thrown when unexpected error occurs
class UnknownException extends AppException {
  const UnknownException({String? message}) : super(message: message);
}
