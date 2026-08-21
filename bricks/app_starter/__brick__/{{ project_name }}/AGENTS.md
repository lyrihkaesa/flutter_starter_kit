# 🤖 AGENTS Guidelines - Flutter Starter Kit

Proyek ini telah dikonfigurasi agar ramah terhadap **AI Coding Assistant** (seperti Google Antigravity, Gemini CLI, Cursor, dll.).

## 📌 Ringkasan Aturan Proyek

1. **Clean Architecture (4 Layers)**:
   - `Presentation` (`lib/presentation/`): UI & BLoC/Cubit. State WAJIB `@freezed`.
   - `Domain` (`lib/domain/`): Pure Dart rules. Mengembalikan `Either<Failure, T>`. Tanpa import UI / Data package.
   - `Data` (`lib/data/`): Models DTO, DataSources (Dio/SharedPreferences), dan `RepositoryImpl`.
   - `Core` (`lib/core/`): Global utils, errors, constants, dan theme.

2. **Dependency Injection & Generation**:
   - Gunakan anotasi `@injectable` / `@lazySingleton`.
   - Setelah modifikasi model/state/di, jalankan: `flutter pub run build_runner build --delete-conflicting-outputs`.

3. **Testing Standard**:
   - `test/` mencerminkan struktur `lib/`.
   - Gunakan `bloc_test`, `http_mock_adapter`, dan `provideDummy<Either<Failure, T>>`.

4. **Code Cleanliness**:
   - DILARANG menggunakan `print()`. Gunakan logger profesional atau `DevLog`.

---
> 💡 *Untuk petunjuk bertahap (rules & skills) yang lebih mendalam, lihat direktori `.agents/`.*
