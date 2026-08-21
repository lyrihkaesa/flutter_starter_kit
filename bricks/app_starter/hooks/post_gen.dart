import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final logger = context.logger;
  final projectName = context.vars['project_name'] as String? ?? 'my_app';

  Directory projectDir = Directory(projectName);
  if (!projectDir.existsSync()) {
    projectDir = Directory.current;
  }

  // 1. Copy .env.example to .env
  final envExample = File('${projectDir.path}/.env.example');
  if (await envExample.exists()) {
    await envExample.copy('${projectDir.path}/.env');
    logger.info('Dibuat .env dari .env.example');
  }

  // 2. Run flutter pub get
  var progress = logger.progress('Menjalankan flutter pub get...');
  try {
    final result = await Process.run(
      'flutter',
      ['pub', 'get'],
      workingDirectory: projectDir.path,
    );
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
      workingDirectory: projectDir.path,
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
