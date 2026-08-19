# 🧪 Standar Unit Testing (100% Reliability)

## 1. Lokasi & Struktur Test
- Struktur direktori `test/` WAJIB mencerminkan (mirror) struktur `lib/`.
- Contoh: `lib/domain/usecases/get_user.dart` -> `test/domain/usecases/get_user_test.dart`.

## 2. Mocking Guidelines
- **Remote DataSource**: Gunakan `http_mock_adapter` (`DioAdapter`) atau `mockito`.
- **Local DataSource**: Inisialisasi `SharedPreferences.setMockInitialValues({})` pada blok `setUp()`.
- **Repositories & UseCases**:
  - Gunakan `provideDummy<Either<Failure, T>>(...)` di `setUpAll()` saat mengujikan interface yang mengembalikan `Either`.
- **BLoC / Cubit**: Gunakan package `bloc_test` dan `mockito` / `mocktail`.
