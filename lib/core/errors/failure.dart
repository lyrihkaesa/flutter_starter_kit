import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.server({String? message, String? error, String? errorDescription}) = ServerFailure;

  const factory Failure.validation(Map<String, List<String>> errors, {String? message}) = ValidationFailure;

  const factory Failure.unauthorized({String? message, String? error, String? errorDescription}) = UnauthorizedFailure;

  const factory Failure.tokenExpired({String? message, String? error, String? errorDescription}) = TokenExpiredFailure;

  const factory Failure.connection({String? message}) = ConnectionFailure;

  const factory Failure.database({String? message}) = DatabaseFailure;

  const factory Failure.unknown({String? message}) = UnknownFailure;
}
