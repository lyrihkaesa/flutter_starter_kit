import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/failure.dart';
import '../../../domain/usecases/auth/check_auth_status.dart';
import '../../../domain/usecases/auth/get_me.dart';
import '../../../domain/usecases/auth/login.dart';
import '../../../domain/usecases/auth/logout.dart';
import '../../../domain/usecases/auth/register.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GetMeUseCase _getMeUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  AuthBloc(
    this._loginUseCase,
    this._registerUseCase,
    this._getMeUseCase,
    this._logoutUseCase,
    this._checkAuthStatusUseCase,
  ) : super(const AuthState.initial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginSubmitted>(_onLoginSubmitted);
    on<AuthRegisterSubmitted>(_onRegisterSubmitted);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final tokenResult = await _checkAuthStatusUseCase();

    await tokenResult.fold(
      (failure) async {
        emit(const AuthState.unauthenticated());
      },
      (token) async {
        if (token == null || token.isEmpty) {
          emit(const AuthState.unauthenticated());
        } else {
          final meResult = await _getMeUseCase();
          meResult.fold(
            (failure) => emit(const AuthState.unauthenticated()),
            (user) => emit(AuthState.authenticated(user)),
          );
        }
      },
    );
  }

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
      deviceName: event.deviceName,
    );

    result.fold(
      (failure) {
        switch (failure) {
          case ValidationFailure(:final errors, :final message):
            emit(
              AuthState.error(
                message: message ?? 'Validasi gagal',
                validationErrors: errors,
              ),
            );
          case UnauthorizedFailure(:final message):
            emit(
              AuthState.error(
                message: message ?? 'Email atau password salah',
              ),
            );
          default:
            emit(
              AuthState.error(
                message: failure.message ?? 'Terjadi kesalahan saat login',
              ),
            );
        }
      },
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onRegisterSubmitted(
    AuthRegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _registerUseCase(
      name: event.name,
      email: event.email,
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
      deviceName: event.deviceName,
    );

    result.fold(
      (failure) {
        switch (failure) {
          case ValidationFailure(:final errors, :final message):
            emit(
              AuthState.error(
                message: message ?? 'Validasi gagal',
                validationErrors: errors,
              ),
            );
          default:
            emit(
              AuthState.error(
                message: failure.message ?? 'Terjadi kesalahan saat pendaftaran',
              ),
            );
        }
      },
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    await _logoutUseCase();
    emit(const AuthState.unauthenticated());
  }
}
