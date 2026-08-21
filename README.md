# Kaesa Flutter Starter Kit

Flutter Starter Kit berbasis **Clean Architecture** (Presentation, Domain, Data, Core) yang ramah terhadap pengembangan cepat, modularitas tinggi, dan dukungan penuh **Mason CLI** serta **AI Coding Assistant**.

---

## ⚡ Panduan Cepat: Men-generate Aplikasi Baru via CLI

Anda dapat men-generate proyek Flutter Clean Architecture baru langsung dari terminal tanpa harus meng-clone repository ini secara manual.

### Langkah 1: Install Mason CLI (Cukup Sekali)
```bash
dart pub global activate mason_cli
```

### Langkah 2: Tambahkan Brick `app_starter` ke Mason Global
```bash
mason add -g app_starter --git-url https://github.com/lyrihkaesa/flutter_starter_kit.git --git-path bricks/app_starter
```

### Langkah 3: Generate Aplikasi Baru

#### 🟢 Opsi A: Mode Interaktif (Tanya Jawab Terminal)
```bash
mason make app_starter -g
```
*Mason akan menanyakan nama proyek, org name, deskripsi, serta konfirmasi apakah ingin menggunakan modul Auth (`y/n`).*

#### ⚡ Opsi B: Mode One-Liner CLI

* **Generate Aplikasi TANPA Auth** (Langsung ke halaman utama / fitur baru):
  ```bash
  mason make app_starter -g --project_name my_app --org_name com.example --include_auth false -o ./my_app
  ```

* **Generate Aplikasi DENGAN Auth** (Lengkap dengan Login, Register, AuthBloc):
  ```bash
  mason make app_starter -g --project_name my_app --org_name com.example --include_auth true -o ./my_app
  ```

### Langkah 4: Jalankan Aplikasi Baru
```bash
cd my_app
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
