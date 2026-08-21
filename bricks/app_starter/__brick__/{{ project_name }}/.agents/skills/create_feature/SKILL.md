---
name: create-feature
description: Workflow langkah demi langkah untuk membuat fitur baru berstandar Clean Architecture di Flutter.
---

# 🚀 Workflow Membuat Fitur Baru (Clean Architecture)

Ikuti urutan pembuatan file berikut saat pengguna meminta pembuatan fitur baru (contoh: "buatkan fitur profil"):

## 1. Domain Layer (`lib/domain/`)
- Buat Entity di `lib/domain/entities/<feature_name>.dart` (menggunakan `@freezed` atau Plain Dart).
- Buat Repository Interface di `lib/domain/repositories/<feature_name>_repository.dart` yang mengembalikan `Either<Failure, T>`.
- Buat UseCase(s) di `lib/domain/usecases/<usecase_name>.dart` bertipe `@lazySingleton` atau `@injectable`.

## 2. Data Layer (`lib/data/`)
- Buat Model/DTO di `lib/data/models/<feature_name>_model.dart` (menggunakan `@freezed` & `@JsonSerializable`).
- Buat DataSources di `lib/data/datasources/`:
  - `RemoteDataSource`: menggunakan `Dio` dan melempar `ServerException`.
  - `LocalDataSource`: melempar `DatabaseException`.
- Buat Repository Implementation di `lib/data/repositories/<feature_name>_repository_impl.dart` dengan anotasi `@LazySingleton(as: FeatureRepository)`. Catch Exception dan kembalikan `Left(Failure)`.

## 3. Presentation Layer (`lib/presentation/`)
- Buat State & BLoC/Cubit di `lib/presentation/bloc/<feature_name>/` dengan anotasi `@injectable`. State buatan WAJIB immutable dengan `@freezed`.
- Buat Page & Screen Widgets di `lib/presentation/pages/` dan `lib/presentation/widgets/`.

## 4. Regenerasi Kode & Uji
- Jalankan `build_runner`:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```
- Buat unit test dasar di `test/` sesuai skenario utama.
