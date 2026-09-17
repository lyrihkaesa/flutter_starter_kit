import 'package:flutter_starter_kit/data/models/responses/response_model.dart';
import 'package:flutter_starter_kit/data/models/responses/user_model.dart';
import 'package:flutter_starter_kit/domain/entities/responses/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponseModel & Response Entity', () {
    test('Non-paginated response: isPaginated bernilai false dan data terisi dengan benar', () {
      final json = {
        'message': 'Data user berhasil diambil',
        'data': {
          'id': '1',
          'name': 'John Doe',
          'email': 'john@example.com',
          'roles': ['admin'],
        },
      };

      final responseModel = ResponseModel<UserModel>.fromJson(
        json,
        (data) => UserModel.fromJson(data as Map<String, dynamic>),
      );

      expect(responseModel.isPaginated, isFalse);
      expect(responseModel.message, 'Data user berhasil diambil');
      expect(responseModel.data?.name, 'John Doe');
      expect(responseModel.meta, isNull);

      final entityResponse = responseModel.toEntity<User>((m) => m.toEntity());
      expect(entityResponse.isPaginated, isFalse);
      expect(entityResponse.data?.name, 'John Doe');
      expect(entityResponse.meta, isNull);
    });

    test('Paginated response: isPaginated bernilai true dan meta ter-deserialisasi dengan benar', () {
      final json = {
        'message': 'List users',
        'data': [
          {
            'id': '1',
            'name': 'User 1',
            'email': 'user1@example.com',
          },
          {
            'id': '2',
            'name': 'User 2',
            'email': 'user2@example.com',
          },
        ],
        'meta': {
          'current_page': 1,
          'from': 1,
          'last_page': 5,
          'per_page': 10,
          'to': 2,
          'total': 50,
          'links': [
            {'url': 'http://api.test?page=1', 'label': '1', 'active': true},
            {'url': 'http://api.test?page=2', 'label': '2', 'active': false},
          ],
        },
      };

      final responseModel = ResponseModel<List<UserModel>>.fromJson(
        json,
        (data) => (data as List<dynamic>)
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      expect(responseModel.isPaginated, isTrue);
      expect(responseModel.data?.length, 2);
      expect(responseModel.meta?.currentPage, 1);
      expect(responseModel.meta?.lastPage, 5);
      expect(responseModel.meta?.total, 50);

      final entityResponse = responseModel.toEntity<List<User>>(
        (list) => list.map((m) => m.toEntity()).toList(),
      );

      expect(entityResponse.isPaginated, isTrue);
      expect(entityResponse.data?.length, 2);
      expect(entityResponse.meta?.hasNextPage, isTrue);
      expect(entityResponse.meta?.hasPreviousPage, isFalse);
      expect(entityResponse.meta?.links?.first.active, isTrue);
    });
  });
}
