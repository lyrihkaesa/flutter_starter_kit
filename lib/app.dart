import 'package:flutter/material.dart';
import 'core/themes/app_theme.dart';

import 'core/app_config.dart';
import 'router/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: MyAppConfig.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false, // default: true or other best partice: !kReleaseMode
      routerConfig: goRouter,
      // locale: const Locale('id', 'ID'),
    );
  }
}
