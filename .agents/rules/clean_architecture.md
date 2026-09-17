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
  - Menggunakan entity fleksibel `Response<T>` jika endpoint mengembalikan metadata/pagination (`isPaginated`).

## 3. Data Layer (`lib/data/`)
- **Tanggung Jawab**: Implementasi penarikan & penyimpanan data.
- **Aturan**:
  - `Models` (DTO) bertugas mengubah JSON ke Dart Object (dan Sebaliknya) dengan `freezed` & `json_serializable` atau class model terstandarisasi (`ResponseModel<T>`).
  - `DataSources`:
    - **Hanya Berkomunikasi dengan Dunia Luar**: Bertugas murni melakukan I/O ke API (Dio) atau Local Storage/DB dan mengembalikan Model (DTO).
    - **DILARANG Menangani Error Lokal**: Dilarang membuat blok `try-catch` berulang dengan method privat penanganan error (seperti `_handleDioError`) di setiap method DataSource. Biarkan error I/O mengalir ke Repository.
    - **Clean Data Parameter**: Parameter yang diterima DataSource harus sudah siap pakai tanpa pembacaan file/konversi mentah di dalam DataSource.
  - `RepositoryImpl`:
    - **Pengambil Keputusan Error & Data**: Mengimplementasikan interface domain dan bertanggung jawab penuh menangkap exception (`DioException`, `AppException`, dll.) lalu memutuskannya menjadi `Either<Failure, T>`.
    - Gunakan fungsi pembungkus terpusat `safeRepositoryCall` dari Core Layer untuk konsistensi penanganan error.
    - Bertanggung jawab penuh melakukan mapping dari Model DTO ke Domain Entity.

## 4. Core Layer (`lib/core/`)
- **Tanggung Jawab**: Utilitas global, tema, penanganan error (`Failure` & `Exception`), utilitas eksekusi aman (`safeRepositoryCall`), dan konstanta.
