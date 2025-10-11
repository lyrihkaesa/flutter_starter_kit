import 'package:flutter/material.dart';
import 'core/themes/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection.dart';
import 'presentation/bloc/app_theme/app_theme_bloc.dart';

import 'core/app_config.dart';
import 'router/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AppThemeBloc>()..add(const AppThemeEvent.started()),
      child: BlocBuilder<AppThemeBloc, AppThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: MyAppConfig.appName,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: state.themeMode,
            debugShowCheckedModeBanner: false, // default: true or other best partice: !kReleaseMode
            routerConfig: goRouter,
            // locale: const Locale('id', 'ID'),
          );
        },
      ),
    );
  }
}
