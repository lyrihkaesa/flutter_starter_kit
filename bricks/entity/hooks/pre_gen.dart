import 'package:mason/mason.dart';

void run(HookContext context) {
  final rawFields = (context.vars['fields'] as List?) ?? [];
  final parsedFields = rawFields.map((f) {
    final field = f.toString().trim();
    final parts = field.split(':');
    if (parts.length == 2) {
      final type = parts[0].trim();
      final name = parts[1].trim();

      final hasQuestionMark = type.endsWith('?');

      return {
        'fieldType': type,
        'fieldName': name,
        'requiredKeyword': hasQuestionMark ? '' : 'required ',
      };
    }
    throw Exception("Field harus dalam format type:name, contoh: int:id atau String?:avatar");
  }).toList();

  context.vars = {
    ...context.vars,
    'fields': parsedFields,
  };
}
