# Kaesa Flutter Starter Kit

Flutter Starter Kit berbasis **Clean Architecture** (Presentation, Domain, Data, Core) yang ramah terhadap pengembangan cepat, modularitas tinggi, dan dukungan penuh **Mason CLI** serta **AI Coding Assistant**.

---

## ⚡ Panduan Cepat: Global CLI Command (`flutter_starter`)

Pengguna **tidak perlu meng-clone repositori ini secara manual**. Cukup aktifkan perintah global `flutter_starter` sekali di terminal:

### 1. Install CLI secara global (Cukup sekali dari terminal mana saja):
```bash
dart pub global activate --source git https://github.com/lyrihkaesa/flutter_starter_kit.git
```

### 2. Generate project Flutter baru dari lokasi folder mana saja:
```bash
flutter_starter my_awesome_app --org com.mycompany
```

### 📍 Opsi Tambahan:

#### Menentukan platform spesifik (dipisahkan koma)
```bash
flutter_starter my_awesome_app --org com.mycompany --platforms android,ios,web
```

#### Menentukan platform menggunakan flag individual
```bash
flutter_starter my_awesome_app --org com.mycompany --android --ios
```

#### Menentukan folder output spesifik
```bash
flutter_starter my_awesome_app --org com.mycompany --output /path/tujuan/my_awesome_app
```

#### Langsung menjalankan build_runner secara otomatis setelah generate
```bash
flutter_starter my_awesome_app --org com.mycompany --build-runner
```

> **💡 Pemilihan Platform**: Jika Anda tidak menyertakan opsi platform di CLI, terminal akan menampilkan prompt interaktif (default: `android,ios`). Folder native (`android`, `ios`, `web`, dll) digenerate secara bersih menggunakan `flutter create` sesuai pilihan Anda.

---

### 🚀 Langkah Selanjutnya:

#### 1. Masuk ke direktori proyek baru:
```bash
cd my_awesome_app
```

#### 2. Jalankan build_runner:
```bash
dart run build_runner build --delete-conflicting-outputs
```

#### 3. Jalankan aplikasi Flutter:
```bash
flutter run
```

---

## 🧱 Mason Bricks untuk Component Generation

Gunakan Mason Bricks untuk men-generate komponen Clean Architecture (Feature Level) pada proyek:

```bash
mason get
```

| Nama Brick | Scope | Kegunaan |
| :--- | :--- | :--- |
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
```

```bash
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
