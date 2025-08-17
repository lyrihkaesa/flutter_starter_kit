import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) {
  final useEntity = context.vars['useEntity'] == true;
  if (!useEntity) return;

  final name = context.vars['name'] as String;
  final fields = context.vars['fields'] as List;

  final snake = _snakeCase(name);
  final pascal = _pascalCase(name);

  final buffer = StringBuffer();
  buffer.writeln("import 'package:freezed_annotation/freezed_annotation.dart';");
  buffer.writeln();
  buffer.writeln("part '${snake}.freezed.dart';");
  buffer.writeln();
  buffer.writeln("@freezed");
  buffer.writeln("sealed class $pascal with _\$$pascal {");
  buffer.writeln("  const factory $pascal({");
  for (final field in fields) {
    buffer.writeln("    ${field['requiredKeyword']}${field['fieldType']} ${field['fieldName']},");
  }
  buffer.writeln("  }) = _${pascal};");
  buffer.writeln();
  buffer.writeln("  const $pascal._();");
  buffer.writeln("}");

  final outDir = Directory('lib/domain/entities');
  if (!outDir.existsSync()) {
    outDir.createSync(recursive: true);
  }

  final file = File('${outDir.path}/$snake.dart');
  file.writeAsStringSync(buffer.toString());
}

String _snakeCase(String input) =>
    input.replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]}_${m[2]}').toLowerCase();

String _pascalCase(String input) => input.substring(0, 1).toUpperCase() + input.substring(1);
