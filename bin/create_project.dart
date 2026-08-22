// ignore_for_file: avoid_print

import 'dart:io';

const availablePlatforms = ['android', 'ios', 'web', 'linux', 'macos', 'windows'];

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

  // Parse optional arguments
  String orgName = 'com.example';
  String? customOutputPath;
  bool runBuildRunner = false;
  List<String> selectedPlatforms = [];

  for (var i = 1; i < args.length; i++) {
    final arg = args[i];
    if (arg == '--org' && i + 1 < args.length) {
      orgName = args[i + 1].trim();
      i++;
    } else if (arg == '--output' && i + 1 < args.length) {
      customOutputPath = args[i + 1].trim();
      i++;
    } else if (arg == '--build-runner') {
      runBuildRunner = true;
    } else if (arg == '--platforms' && i + 1 < args.length) {
      final platformsInput = args[i + 1].trim();
      selectedPlatforms = platformsInput
          .split(',')
          .map((p) => p.trim().toLowerCase())
          .where((p) => availablePlatforms.contains(p))
          .toList();
      i++;
    } else if (arg.startsWith('--') && availablePlatforms.contains(arg.substring(2).toLowerCase())) {
      final platform = arg.substring(2).toLowerCase();
      if (!selectedPlatforms.contains(platform)) {
        selectedPlatforms.add(platform);
      }
    }
  }

  // Prompt jika platform belum ditentukan lewat CLI
  if (selectedPlatforms.isEmpty) {
    selectedPlatforms = _promptPlatforms();
  }

  final currentDir = Directory.current;
  final targetPath = customOutputPath ?? '${currentDir.path}/$newProjectName';
  final targetDir = Directory(targetPath);

  print('\n🚀 Generating Flutter Project & AI Rules (flutter_starter)...');
  print('   • Project Name : $newProjectName');
  print('   • Organization : $orgName');
  print('   • Platforms    : ${selectedPlatforms.join(', ')}');
  print('   • Output Path  : ${targetDir.path}\n');

  if (targetDir.existsSync()) {
    print('❌ Error: Folder target "${targetDir.path}" sudah ada.');
    print('   Harap hapus folder tersebut terlebih dahulu atau gunakan nama project lain.');
    exit(1);
  }

  // Langkah 1: Jalankan "flutter create" untuk membuat folder platform native bersih
  print('🛠️ Running "flutter create" for platforms: ${selectedPlatforms.join(', ')}...');
  final flutterCreateResult = await Process.run(
    'flutter',
    [
      'create',
      '--org',
      orgName,
      '--project-name',
      newProjectName,
      '--platforms',
      selectedPlatforms.join(','),
      targetDir.path,
    ],
    runInShell: true,
  );

  if (flutterCreateResult.exitCode != 0) {
    print('❌ Error: Gagal menjalankan "flutter create".');
    print(flutterCreateResult.stderr);
    exit(1);
  }
  print('✅ "flutter create" completed.');

  Directory? tempDirToClean;
  Directory sourceDir;

  // Cek apakah dijalankan di dalam repo starter kit lokal (dev mode)
  final localPubspec = File('${currentDir.path}/pubspec.yaml');
  final isLocalRepo = localPubspec.existsSync() &&
      localPubspec.readAsStringSync().contains('name: flutter_starter_kit');

  if (isLocalRepo) {
    sourceDir = currentDir;
    print('📁 Menggunakan template lokal...');
  } else {
    print('📥 Mengunduh template Flutter Starter Kit terbaru dari GitHub...');
    tempDirToClean = Directory.systemTemp.createTempSync('flutter_starter_kit_');
    final gitCloneResult = await Process.run(
      'git',
      [
        'clone',
        '--depth',
        '1',
        'https://github.com/lyrihkaesa/flutter_starter_kit.git',
        tempDirToClean.path
      ],
      runInShell: true,
    );

    if (gitCloneResult.exitCode != 0) {
      print('❌ Error: Gagal mengunduh template dari GitHub.');
      print(gitCloneResult.stderr);
      _cleanupTemp(tempDirToClean);
      exit(1);
    }
    sourceDir = tempDirToClean;
  }

  try {
    // Platform native & dev files diabaikan agar tidak menimpa buatan `flutter create`
    final ignoredPaths = {
      'android',
      'ios',
      'web',
      'windows',
      'macos',
      'linux',
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
      'bin',
      'tool',
      'scratch',
    };

    print('📂 Copying starter kit files & AI Agent rules...');
    _copyDirectory(sourceDir, targetDir, ignoredPaths);

    // Pastikan file .env ada di target project
    final envExample = File('${targetDir.path}/.env.example');
    final envFile = File('${targetDir.path}/.env');
    if (envExample.existsSync() && !envFile.existsSync()) {
      envExample.copySync(envFile.path);
    }

    print('✏️ Updating package name & configuration in project files...');
    final oldOrgPackage = 'io.github.lyrihkaesa.flutterstarterkit.flutter_starter_kit';
    final newOrgPackage = '$orgName.$newProjectName';

    _replaceInDirectory(targetDir, 'flutter_starter_kit', newProjectName);
    _replaceInDirectory(targetDir, oldOrgPackage, newOrgPackage);

    print('📦 Running "flutter pub get" on target project...');
    final pubGetResult = await Process.run(
      'flutter',
      ['pub', 'get'],
      workingDirectory: targetDir.path,
      runInShell: true,
    );

    if (pubGetResult.exitCode != 0) {
      print('⚠️ Warning: "flutter pub get" gagal: ${pubGetResult.stderr}');
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
  } finally {
    _cleanupTemp(tempDirToClean);
  }
}

List<String> _promptPlatforms() {
  if (!stdin.hasTerminal) {
    // Mode non-interaktif (misal dipanggil dari CI/CD tanpa TTY)
    return ['android', 'ios'];
  }

  print('📱 Pilih platform yang ingin disupport:');
  print('   Opsi yang tersedia: ${availablePlatforms.join(', ')}');
  stdout.write('   Masukkan platform (pisahkan dengan koma, default: android,ios): ');

  final input = stdin.readLineSync();
  if (input == null || input.trim().isEmpty) {
    return ['android', 'ios'];
  }

  final chosen = input
      .split(',')
      .map((p) => p.trim().toLowerCase())
      .where((p) => availablePlatforms.contains(p))
      .toList();

  if (chosen.isEmpty) {
    print('⚠️ Input tidak valid. Menggunakan default: android, ios');
    return ['android', 'ios'];
  }

  return chosen;
}

void _cleanupTemp(Directory? tempDir) {
  if (tempDir != null && tempDir.existsSync()) {
    try {
      tempDir.deleteSync(recursive: true);
    } catch (_) {}
  }
}

void _printUsage() {
  print('''
Flutter Starter Kit CLI Generator (flutter_starter)

Usage:
  flutter_starter <new_project_name> [options]
  
  (Atau jika running via dev mode):
  dart run bin/create_project.dart <new_project_name> [options]

Options:
  --org <org_name>          Package organization (default: com.example)
  --output <path>             Custom output path untuk project baru
  --platforms <list>          Daftar platform dipisahkan koma (contoh: android,ios,web)
  --android, --ios, --web...  Individual platform flags
  --build-runner              Jalankan build_runner secara otomatis setelah generation

Example:
  flutter_starter my_awesome_app --org com.mycompany --platforms android,ios,web
  flutter_starter my_awesome_app --android --ios
''');
}

void _copyDirectory(Directory source, Directory destination, Set<String> ignoredNames) {
  final destCanonical = destination.absolute.path;

  for (var entity in source.listSync(recursive: false)) {
    final name = entity.path.split(Platform.pathSeparator).last;
    if (ignoredNames.contains(name)) continue;

    if (entity is Directory) {
      final entityCanonical = entity.absolute.path;
      if (entityCanonical == destCanonical || destCanonical.startsWith('$entityCanonical/')) {
        continue;
      }
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
