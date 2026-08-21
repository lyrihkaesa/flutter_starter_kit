import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app_config.dart';
import 'core/themes/app_theme.dart';
import 'injection.dart';
import 'presentation/bloc/app_theme/app_theme_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart';
import 'router/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AppThemeBloc>()..add(const AppThemeEvent.started()),
        ),
        BlocProvider(
          create: (context) => getIt<AuthBloc>()..add(const AuthEvent.checkRequested()),
        ),
      ],
      child: BlocBuilder<AppThemeBloc, AppThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: MyAppConfig.appName,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: state.themeMode,
            debugShowCheckedModeBanner: false,
            routerConfig: goRouter,
          );
        },
      ),
    );
  }
}
