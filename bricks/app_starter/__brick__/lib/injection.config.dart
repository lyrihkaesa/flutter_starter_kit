// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'data/datasources/local/app_theme_local_data_source.dart' as _i721;
import 'data/datasources/local/auth_local_datasource.dart' as _i851;
import 'data/datasources/remote/auth_remote_data_source.dart' as _i386;
import 'data/datasources/remote/auth_remote_datasource.dart' as _i86;
import 'data/repositories_impl/app_theme_repository_impl.dart' as _i78;
import 'data/repositories_impl/auth_repository_impl.dart' as _i66;
import 'domain/repositories/app_theme_repository.dart' as _i91;
import 'domain/repositories/auth_repository.dart' as _i716;
import 'domain/usecases/auth/check_auth_status.dart' as _i186;
import 'domain/usecases/auth/get_me.dart' as _i138;
import 'domain/usecases/auth/login.dart' as _i203;
import 'domain/usecases/auth/logout.dart' as _i517;
import 'domain/usecases/auth/register.dart' as _i1063;
import 'domain/usecases/theme/load_theme.dart' as _i49;
import 'domain/usecases/theme/save_theme.dart' as _i7;
import 'injection.dart' as _i464;
import 'presentation/bloc/app_theme/app_theme_bloc.dart' as _i310;
import 'presentation/bloc/auth/auth_bloc.dart' as _i605;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final externalsModule = _$ExternalsModule();
  gh.lazySingleton<_i558.FlutterSecureStorage>(
    () => externalsModule.secureStorage,
  );
  gh.lazySingleton<_i721.AppThemeLocalDataSource>(
    () => const _i721.AppThemeLocalDataSourceImpl(),
  );
  gh.lazySingleton<_i851.AuthLocalDataSource>(
    () => _i851.AuthLocalDataSourceImpl(gh<_i558.FlutterSecureStorage>()),
  );
  gh.lazySingleton<_i361.Dio>(
    () => externalsModule.dio(gh<_i558.FlutterSecureStorage>()),
  );
  gh.lazySingleton<_i91.AppThemeRepository>(
    () => _i78.AppThemeRepositoryImpl(
      appThemeLocalDataSource: gh<_i721.AppThemeLocalDataSource>(),
    ),
  );
  gh.lazySingleton<_i49.LoadTheme>(
    () => _i49.LoadTheme(gh<_i91.AppThemeRepository>()),
  );
  gh.lazySingleton<_i7.SaveTheme>(
    () => _i7.SaveTheme(gh<_i91.AppThemeRepository>()),
  );
  gh.lazySingleton<_i86.AuthRemoteDataSource>(
    () => _i86.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
  );
  gh.factory<_i310.AppThemeBloc>(
    () => _i310.AppThemeBloc(
      loadTheme: gh<_i49.LoadTheme>(),
      saveTheme: gh<_i7.SaveTheme>(),
    ),
  );
  gh.lazySingleton<_i386.AuthRemoteDataSource>(
    () => _i386.AuthRemoteDataSourceImpl(dio: gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i716.AuthRepository>(
    () => _i66.AuthRepositoryImpl(
      gh<_i86.AuthRemoteDataSource>(),
      gh<_i851.AuthLocalDataSource>(),
    ),
  );
  gh.lazySingleton<_i186.CheckAuthStatusUseCase>(
    () => _i186.CheckAuthStatusUseCase(gh<_i716.AuthRepository>()),
  );
  gh.lazySingleton<_i138.GetMeUseCase>(
    () => _i138.GetMeUseCase(gh<_i716.AuthRepository>()),
  );
  gh.lazySingleton<_i203.LoginUseCase>(
    () => _i203.LoginUseCase(gh<_i716.AuthRepository>()),
  );
  gh.lazySingleton<_i517.LogoutUseCase>(
    () => _i517.LogoutUseCase(gh<_i716.AuthRepository>()),
  );
  gh.lazySingleton<_i1063.RegisterUseCase>(
    () => _i1063.RegisterUseCase(gh<_i716.AuthRepository>()),
  );
  gh.factory<_i605.AuthBloc>(
    () => _i605.AuthBloc(
      gh<_i203.LoginUseCase>(),
      gh<_i1063.RegisterUseCase>(),
      gh<_i138.GetMeUseCase>(),
      gh<_i517.LogoutUseCase>(),
      gh<_i186.CheckAuthStatusUseCase>(),
    ),
  );
  return getIt;
}

class _$ExternalsModule extends _i464.ExternalsModule {}
