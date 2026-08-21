// ignore_for_file: avoid_print

import 'dart:io';


void main(List<String> args) async {
  if (args.isEmpty || args.contains('--help') || args.contains('-h')) {
    _printUsage();
    exit(0);
  }

  final newProjectName = args[0].trim();
  final nameRegExp = RegExp(r'^[a-z][a-z0-9_]*$');
  if (!nameRegExp.hasMatch(newProjectName)) {
    print('❌ Error: Nama project "$newProjectName" tidak valid.');
    print('   Nama project harus menggunakan format snake_case (misal: my_awesome_app).');
    exit(1);
  }

  // Parse optional arguments --org dan --output
  String orgName = 'com.example';
  String? customOutputPath;
  bool runBuildRunner = false;

  for (var i = 1; i < args.length; i++) {
    if (args[i] == '--org' && i + 1 < args.length) {
      orgName = args[i + 1].trim();
      i++;
    } else if (args[i] == '--output' && i + 1 < args.length) {
      customOutputPath = args[i + 1].trim();
      i++;
    } else if (args[i] == '--build-runner') {
      runBuildRunner = true;
    }
  }

  final rootDir = Directory.current;
  final targetPath = customOutputPath ?? '${rootDir.parent.path}/$newProjectName';
  final targetDir = Directory(targetPath);

  print('🚀 Generating Flutter Project & AI Rules...');
  print('   • Project Name : $newProjectName');
  print('   • Organization : $orgName');
  print('   • Output Path  : ${targetDir.path}\n');

  if (targetDir.existsSync()) {
    print('❌ Error: Folder target "${targetDir.path}" sudah ada.');
    print('   Harap hapus folder tersebut terlebih dahulu atau gunakan nama project lain.');
    exit(1);
  }

  targetDir.createSync(recursive: true);

  // List folder & file yang akan di-ignore dari pengkopian
  final ignoredPaths = {
    '.git',
    '.dart_tool',
    'build',
    '.fvm',
    '.idea',
    '.vscode',
    'pubspec.lock',
    'coverage',
    'bricks',
    '.DS_Store',
    'tool', // Tidak perlu mengikutsertakan tool generator di project baru
  };

  print('📁 Copying starter kit files...');
  _copyDirectory(rootDir, targetDir, ignoredPaths);

  // Pastikan file .env ada di target project
  final envExample = File('${targetDir.path}/.env.example');
  final envFile = File('${targetDir.path}/.env');
  if (envExample.existsSync() && !envFile.existsSync()) {
    envExample.copySync(envFile.path);
  }

  print('✏️ Updating package name & org configuration...');
  final oldOrgPackage = 'io.github.lyrihkaesa.flutterstarterkit.flutter_starter_kit';
  final newOrgPackage = '$orgName.$newProjectName';

  _replaceInDirectory(targetDir, 'flutter_starter_kit', newProjectName);
  _replaceInDirectory(targetDir, oldOrgPackage, newOrgPackage);

  // Refactor struktur folder Kotlin MainActivity
  _refactorKotlinPackage(targetDir, orgName, newProjectName);

  print('📦 Running "flutter pub get" on target project...');
  final pubGetResult = await Process.run(
    'flutter',
    ['pub', 'get'],
    workingDirectory: targetDir.path,
    runInShell: true,
  );

  if (pubGetResult.exitCode != 0) {
    print('⚠️ Warning: "flutter pub get" gagal dijalankan:');
    print(pubGetResult.stderr);
  } else {
    print('✅ "flutter pub get" finished successfully.');
  }

  if (runBuildRunner) {
    print('⚙️ Running "build_runner" on target project...');
    final buildRunnerResult = await Process.run(
      'dart',
      ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      workingDirectory: targetDir.path,
      runInShell: true,
    );
    if (buildRunnerResult.exitCode != 0) {
      print('⚠️ Warning: "build_runner" gagal: ${buildRunnerResult.stderr}');
    } else {
      print('✅ "build_runner" finished successfully.');
    }
  }

  print('\n======================================================');
  print('🎉 Project "$newProjectName" berhasil dibuat!');
  print('======================================================');
  print('Langkah berikutnya:');
  print('  1. cd ${targetDir.path}');
  if (!runBuildRunner) {
    print('  2. dart run build_runner build --delete-conflicting-outputs');
    print('  3. flutter run');
  } else {
    print('  2. flutter run');
  }
  print('\nAI Rules & Skills (.agents/ & AGENTS.md) sudah aktif untuk project baru ini! 🤖✨\n');
}

void _printUsage() {
  print('''
Flutter Project Generator + AI Rules

Usage:
  dart run tool/create_project.dart <new_project_name> [options]

Options:
  --org <org_name>      Package organization (default: com.example)
  --output <path>       Custom output path for the new project
  --build-runner        Jalankan build_runner secara otomatis setelah generation

Example:
  dart run tool/create_project.dart my_awesome_app --org com.mycompany
''');
}

void _copyDirectory(Directory source, Directory destination, Set<String> ignoredNames) {
  for (var entity in source.listSync(recursive: false)) {
    final name = entity.path.split(Platform.pathSeparator).last;
    if (ignoredNames.contains(name)) continue;

    if (entity is Directory) {
      final newDir = Directory('${destination.path}/$name');
      newDir.createSync(recursive: true);
      _copyDirectory(entity, newDir, ignoredNames);
    } else if (entity is File) {
      entity.copySync('${destination.path}/$name');
    }
  }
}

void _replaceInDirectory(Directory dir, String fromText, String toText) {
  for (var entity in dir.listSync(recursive: true)) {
    if (entity is File) {
      final path = entity.path;

      // Filter file biner / asset gambar
      if (path.endsWith('.png') ||
          path.endsWith('.jpg') ||
          path.endsWith('.jpeg') ||
          path.endsWith('.gif') ||
          path.endsWith('.ico') ||
          path.endsWith('.ttf') ||
          path.endsWith('.woff') ||
          path.endsWith('.pdf') ||
          path.endsWith('.zip')) {
        continue;
      }

      try {
        final content = entity.readAsStringSync();
        if (content.contains(fromText)) {
          final updated = content.replaceAll(fromText, toText);
          entity.writeAsStringSync(updated);
        }
      } catch (_) {
        // Skip file biner yang gagal dibaca sebagai String
      }
    }
  }
}

void _refactorKotlinPackage(Directory targetDir, String orgName, String projectName) {
  final kotlinSrcBase = Directory('${targetDir.path}/android/app/src/main/kotlin');
  if (!kotlinSrcBase.existsSync()) return;

  final oldMainActivity = File(
    '${kotlinSrcBase.path}/io/github/lyrihkaesa/flutterstarterkit/flutter_starter_kit/MainActivity.kt',
  );

  final orgParts = orgName.split('.');
  final newRelPath = [...orgParts, projectName].join('/');
  final newKotlinDir = Directory('${kotlinSrcBase.path}/$newRelPath');

  if (oldMainActivity.existsSync()) {
    newKotlinDir.createSync(recursive: true);
    final newPackageName = '$orgName.$projectName';
    final content = oldMainActivity.readAsStringSync();
    final updatedContent = content.replaceAll(
      RegExp(r'package\s+[a-zA-Z0-9_.]+'),
      'package $newPackageName',
    );

    final newMainActivity = File('${newKotlinDir.path}/MainActivity.kt');
    newMainActivity.writeAsStringSync(updatedContent);

    // Hapus folder kotlin lama 'io' jika sudah kosong
    final oldIoDir = Directory('${kotlinSrcBase.path}/io');
    if (oldIoDir.existsSync()) {
      try {
        oldIoDir.deleteSync(recursive: true);
      } catch (_) {}
    }
  }
}
