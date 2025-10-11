import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/app_config.dart';
import 'presentation/bloc/app_theme/app_theme_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load config file before running the application
  await MyAppConfig.load();

  runApp(const MyApp());
}
