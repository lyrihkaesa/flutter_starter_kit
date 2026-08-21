import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
abstract class AuthEvent with _$AuthEvent {
  const factory AuthEvent.checkRequested() = AuthCheckRequested;

  const factory AuthEvent.loginSubmitted({
    required String email,
    required String password,
    String? deviceName,
  }) = AuthLoginSubmitted;

  const factory AuthEvent.registerSubmitted({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? deviceName,
  }) = AuthRegisterSubmitted;

  const factory AuthEvent.logoutRequested() = AuthLogoutRequested;
}
