import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/responses/user.dart';


part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;

  const factory AuthState.loading() = _Loading;

  const factory AuthState.authenticated(User user) = _Authenticated;

  const factory AuthState.unauthenticated() = _Unauthenticated;

  const factory AuthState.error({
    required String message,
    Map<String, List<String>>? validationErrors,
  }) = _Error;
}
