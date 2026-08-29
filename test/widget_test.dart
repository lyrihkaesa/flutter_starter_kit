import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_kit/data/models/responses/user_model.dart';
import 'package:flutter_starter_kit/domain/entities/responses/user.dart';

void main() {
  group('UserModel', () {
    test('should correctly deserialize from JSON and convert to entity', () {
      final json = {
        'id': '1',
        'name': 'Super Admin',
        'email': 'superadmin@example.com',
        'avatar_url': 'https://example.com/avatar.png',
        'locale': 'id',
        'timezone': 'Asia/Jakarta',
        'theme': 'dark',
      };

      final model = UserModel.fromJson(json);
      expect(model.id, equals('1'));
      expect(model.name, equals('Super Admin'));
      expect(model.email, equals('superadmin@example.com'));
      expect(model.avatarUrl, equals('https://example.com/avatar.png'));
      expect(model.locale, equals('id'));
      expect(model.timezone, equals('Asia/Jakarta'));
      expect(model.theme, equals('dark'));

      final entity = model.toEntity();
      expect(entity, isA<User>());
      expect(entity.name, equals('Super Admin'));
    });
  });
}

