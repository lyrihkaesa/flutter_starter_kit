---
name: generate-unit-test
description: Panduan pembuatan unit test berstandar tinggi yang menargetkan UseCase, RepositoryImpl, DataSource, atau BLoC.
---

# 🧪 Runbook Pembuatan Unit Test

Ikuti aturan berikut saat memproduksi unit test baru:

## 1. Persiapan File Test
- Buat file test sejajar dengan lokasi file sumber di bawah folder `test/`.
- Contoh: `lib/domain/usecases/get_user.dart` -> `test/domain/usecases/get_user_test.dart`.

## 2. Struktur Mocking
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:fpdart/fpdart.dart';

@GenerateMocks([UserRepository])
import 'get_user_test.mocks.dart';

void main() {
  late GetUser usecase;
  late MockUserRepository mockRepository;

  setUpAll(() {
    // Daftarkan dummy value jika interface mengembalikan Either
    provideDummy<Either<Failure, User>>(const Right(User.empty()));
  });

  setUp(() {
    mockRepository = MockUserRepository();
    usecase = GetUser(mockRepository);
  });

  group('GetUser UseCase', () {
    test('harus mengembalikan User saat call ke repository sukses', () async {
      // arrange
      when(mockRepository.getUser(any)).thenAnswer((_) async => const Right(tUser));

      // act
      final result = await usecase(tId);

      // assert
      expect(result, const Right(tUser));
      verify(mockRepository.getUser(tId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
```

## 3. Eksekusi Test
Jalankan test dengan perintah:
```bash
flutter test
```
