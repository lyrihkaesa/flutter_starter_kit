# 🏛️ Standar Clean Architecture (Layer Isolation)

Setiap pengembangan fitur di proyek ini harus mematuhi struktur pemisahan 4 layer utama di dalam direktori `lib/`:

## 1. Presentation Layer (`lib/presentation/`)
- **Tanggung Jawab**: Menangani UI (Pages, Widgets) dan pengelola State (BLoC / Cubit).
- **Aturan**:
  - DILARANG melakukan panggilan HTTP/Dio atau memanggil DataSource secara langsung dari UI maupun BLoC/Cubit.
  - Panggilan data hanya boleh melalui **UseCases**.
  - State WAJIB bersifat *immutable* menggunakan package `freezed`.

## 2. Domain Layer (`lib/domain/`)
- **Tanggung Jawab**: Logika bisnis murni (Enterprise & Application Business Rules).
- **Aturan**:
  - DILARANG mengimpor paket UI (seperti `package:flutter/material.dart`) atau paket Data/Network (seperti `dio`, `shared_preferences`).
  - Berisi `Entities` (Freezed / Plain Dart objects), `UseCases`, dan interface `Repositories`.
  - Fungsi UseCase & Repository Interface WAJIB mengembalikan `Either<Failure, T>` dari package `fpdart`.

## 3. Data Layer (`lib/data/`)
- **Tanggung Jawab**: Implementasi penarikan & penyimpanan data.
- **Aturan**:
  - `Models` (DTO) bertugas mengubah JSON ke Dart Object (dan Sebaliknya) dengan `freezed` & `json_serializable`.
  - `DataSources`:
    - `RemoteDataSource`: Menggunakan `Dio` / `http` dan melempar `ServerException`.
    - `LocalDataSource`: Menggunakan `SharedPreferences` / `FlutterSecureStorage` / `Sqflite` dan melempar `DatabaseException`.
  - `RepositoryImpl`: Mengimplementasikan interface domain dan menangkap `ServerException` / `DatabaseException` untuk diubah menjadi `Left(Failure)`.

## 4. Core Layer (`lib/core/`)
- **Tanggung Jawab**: Utilitas global, tema, penanganan error (`Failure` & `Exception`), dan konstanta.
