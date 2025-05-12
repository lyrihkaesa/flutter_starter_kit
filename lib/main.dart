import 'package:flutter/material.dart';

import 'app.dart';
import 'core/app_config.dart';

void main() async {
  // Load config file before running the application
  await MyAppConfig.load();

  runApp(const MyApp());
}
