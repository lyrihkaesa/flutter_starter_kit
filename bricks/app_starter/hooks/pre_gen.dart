import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final logger = context.logger;
  final projectName = context.vars['project_name'] as String? ?? 'my_app';
  final orgName = context.vars['org_name'] as String? ?? 'com.example';

  final progress = logger.progress('Menjalankan flutter create...');

  try {
    final result = await Process.run(
      'flutter',
      [
        'create',
        '.',
        '--project-name',
        projectName,
        '--org',
        orgName,
        '--overwrite',
      ],
      workingDirectory: Directory.current.path,
    );

    if (result.exitCode == 0) {
      progress.complete('Flutter project scaffold berhasil dibuat!');
    } else {
      progress.fail('Gagal menjalankan flutter create: ${result.stderr}');
    }
  } catch (e) {
    progress.fail('Gagal membuat proyek Flutter: $e');
  }
}
