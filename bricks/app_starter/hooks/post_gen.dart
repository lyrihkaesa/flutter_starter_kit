import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final logger = context.logger;

  // 1. Copy .env.example to .env
  final envExample = File('.env.example');
  if (await envExample.exists()) {
    await envExample.copy('.env');
    logger.info('Dibuat .env dari .env.example');
  }

  // 2. Run flutter pub get
  var progress = logger.progress('Menjalankan flutter pub get...');
  try {
    final result = await Process.run('flutter', ['pub', 'get']);
    if (result.exitCode == 0) {
      progress.complete('Dependencies berhasil di-install!');
    } else {
      progress.fail('flutter pub get gagal: ${result.stderr}');
    }
  } catch (e) {
    progress.fail('flutter pub get error: $e');
  }

  // 3. Run build_runner
  progress = logger.progress('Menjalankan build_runner...');
  try {
    final result = await Process.run(
      'flutter',
      ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
    );
    if (result.exitCode == 0) {
      progress.complete('Code generation selesai!');
    } else {
      progress.fail('build_runner gagal: ${result.stderr}');
    }
  } catch (e) {
    progress.fail('build_runner error: $e');
  }
}
