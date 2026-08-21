# Kaesa Flutter Starter Kit

Flutter Starter Kit berbasis **Clean Architecture** (Presentation, Domain, Data, Core) yang ramah terhadap pengembangan cepat, modularitas tinggi, dan dukungan penuh **Mason CLI** serta **AI Coding Assistant**.

---

## ⚡ Panduan Cepat: Men-generate Aplikasi Baru via CLI

Anda dapat men-generate proyek Flutter Clean Architecture baru langsung dari terminal dari folder mana saja dari nol sampai siap jalan.

### Langkah 1: Install Mason CLI (Cukup Sekali)
```bash
dart pub global activate mason_cli
```

### Langkah 2: Registrasi Brick `app_starter` ke Global Mason
```bash
mason add -g app_starter --git-url https://github.com/lyrihkaesa/flutter_starter_kit.git --git-path bricks/app_starter
```
> *Jika sudah pernah meng-install versi lama, perbarui dengan:*
> ```bash
> mason remove -g app_starter
> mason add -g app_starter --git-url https://github.com/lyrihkaesa/flutter_starter_kit.git --git-path bricks/app_starter
> ```

---

### 🟢 Cara 1: Sekali Jalan via Mason (Otomatis Full App)

Cukup jalankan 1 perintah berikut di direktori tempat Anda ingin membuat proyek baru. Mason akan otomatis membuat `android/`, `ios/`, `web/`, meng-install `pub`, dan men-generate kode Clean Architecture:

#### ⚡ Mode One-Liner CLI:
* **Tanpa Modul Auth**:
  ```bash
  mason make app_starter --project_name camera_sppg --org_name com.example --description "Camera SPPG App" --include_auth false -o ./camera-sppg
  ```

* **Dengan Modul Auth** (Login, Register, AuthBloc):
  ```bash
  mason make app_starter --project_name camera_sppg --org_name com.example --description "Camera SPPG App" --include_auth true -o ./camera-sppg
  ```

#### 💬 Mode Interaktif (Tanya Jawab Terminal):
```bash
mason make app_starter -o ./camera-sppg
```

Setelah selesai, cukup masuk ke folder dan jalankan:
```bash
cd camera-sppg
flutter run
```

---

### 🛠️ Cara 2: Manual (Flutter Create + Mason Fallback)

Jika Anda ingin men-generate proyek Flutter native dasar terlebih dahulu kemudian menimpanya dengan Clean Architecture Starter Kit:

1. **Buat Proyek Flutter Baru**:
   ```bash
   flutter create --org com.example --project-name camera_sppg camera-sppg
   ```

2. **Terapkan Clean Architecture Brick**:
   ```bash
   cd camera-sppg
   mason make app_starter --on-conflict overwrite
   ```

3. **Setup Environment & Build Code**:
   ```bash
   cp .env.example .env
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   flutter run
   ```

---

## 💻 Panduan Lokal: Clone & Development di Proyek Ini

Jika Anda ingin langsung menggunakan repository ini sebagai basis proyek:

### 1. Clone & Setup Environment
```bash
git clone https://github.com/lyrihkaesa/flutter_starter_kit.git
cd flutter_starter_kit
cp .env.example .env
```

### 2. Gunakan Flutter versi project (FVM)
Pastikan sudah install [FVM](https://fvm.app/docs/getting_started/installation). Lalu jalankan:
```bash
fvm use
```

> ⚠️ **Windows user**:
> - Restart VSCode setelah `fvm use`.
> - Pastikan **Flutter SDK path** di VSCode diarahkan ke `.fvm/flutter_sdk`.
> - Aktifkan "Development Mode" di Windows agar symlink FVM bekerja.

### 3. Install Dependencies & Build Code
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
mason get
```

---

## 🧱 Daftar Mason Bricks yang Tersedia

Repository ini menyediakan Mason Bricks untuk mempercepat pembuatan modul dan komponen Clean Architecture:

| Nama Brick | Scope | Kegunaan |
| :--- | :--- | :--- |
| **`app_starter`** | Project | Men-generate fondasi proyek aplikasi baru (Opsional Auth via `--include_auth`) |
| **`bloc`** | Component | Men-generate BLoC / Cubit berstandar `freezed` |
| **`usecase`** | Component | Men-generate UseCase berstandar `fpdart` (`Either<Failure, T>`) |
| **`repository`** | Component | Men-generate Repository Interface dan RepositoryImpl |
| **`entity`** | Component | Men-generate Domain Entity (`freezed`) |
| **`model`** | Component | Men-generate Data DTO Model (`freezed` + `json_serializable`) |
| **`remote_datasource`** | Component | Men-generate Remote DataSource berbasis Dio |
| **`local_datasource`** | Component | Men-generate Local DataSource berbasis SharedPreferences/SecureStorage |

### Contoh Penggunaan Component Brick:
```bash
mason make bloc --name product
mason make usecase --name get_products
```

---

## 💡 Tips Development

- **Watcher Auto-Generate**:
  Gunakan perintah ini saat koding agar file Freezed & Injectable ter-regenerasi otomatis:
  ```bash
  flutter pub run build_runner watch --delete-conflicting-outputs
  ```
- **FVM**:
  Gunakan perintah `flutter` biasa setelah `fvm use` untuk menjaga konsistensi SDK.

---

## 🤖 AI Agent Ready

Starter Kit ini sudah dilengkapi dengan **AI Agent Configuration** built-in di lokasi [.agents/](file://.agents) dan [AGENTS.md](file://AGENTS.md).

Jika Anda menggunakan AI Pair Programmer (seperti Google Antigravity, Gemini CLI, Cursor, dll.), AI akan secara otomatis:
- Mengetahui standar **Clean Architecture** proyek (`Presentation`, `Domain`, `Data`, `Core`).
- Mengikuti aturan immutability BLoC/Cubit dengan `freezed`.
- Mengetahui kapan harus meng-generate kode dengan `build_runner`.
- Membuat unit test yang konsisten dengan standar mocking proyek.
