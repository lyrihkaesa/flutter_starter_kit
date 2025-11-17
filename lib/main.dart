import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app.dart';
import 'core/app_config.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load config file before running the application
  await MyAppConfig.load();
  configureDependencies();

  // Initialize Sentry for error tracking (only if DSN is provided)
  if (MyAppConfig.sentryDsn != null && MyAppConfig.sentryDsn!.isNotEmpty) {
    await SentryFlutter.init(
      (options) {
        options.dsn = MyAppConfig.sentryDsn;
        options.environment = MyAppConfig.environment;
        options.tracesSampleRate = MyAppConfig.isProduction ? 1.0 : 0.0;
        options.enableAutoSessionTracking = true;
        options.attachScreenshot = true;
        options.attachViewHierarchy = true;
      },
      appRunner: () => runApp(const MyApp()),
    );
  } else {
    runApp(const MyApp());
  }
}
