# ⚙️ Dependency Injection & State Management Standards

## 1. Dependency Injection (GetIt & Injectable)
- Gunakan anotasi `@injectable`, `@lazySingleton`, atau `@singleton` pada:
  - DataSources
  - Repositories (Implementasi)
  - UseCases
  - BLoC / Cubit
- Jalankan `build_runner` setiap kali menambah dependensi baru dengan anotasi `@injectable`.

## 2. State Management (BLoC / Cubit)
- BLoC/Cubit bertanggung jawab mengelola alur status UI.
- Semua State WAJIB dibuat immutable dengan `freezed`.
- Tangani error dengan mengubah `Failure` dari Domain layer menjadi state UI yang ramah pengguna (contoh: `State.error(String message)`).
