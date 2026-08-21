import 'package:flutter/material.dart';

import 'app.dart';
import 'core/app_config.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load config file before running the application
  await MyAppConfig.load();
  configureDependencies();

  runApp(const MyApp());
}
