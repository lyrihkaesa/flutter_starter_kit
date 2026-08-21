# Kaesa Flutter Starter Kit

Flutter Starter Kit berbasis **Clean Architecture** (Presentation, Domain, Data, Core) yang ramah terhadap pengembangan cepat, modularitas tinggi, dan dukungan penuh **Mason CLI** serta **AI Coding Assistant**.

---

## ⚡ Panduan Cepat: Men-generate Aplikasi Baru + AI Rules

Cukup clone repositori ini dan jalankan **1 perintah** (tanpa perlu meng-install tool/package tambahan):

```bash
# 1. Clone & masuk ke repo starter kit
git clone https://github.com/lyrihkaesa/flutter_starter_kit.git
cd flutter_starter_kit

# 2. Run generator project baru
dart run tool/create_project.dart my_awesome_app --org com.mycompany
```

### 📍 Lokasi Hasil Generate
Secara default, project baru akan dibuat **sejajar di luar folder starter kit** (`../<nama_project>`):
```
📁 Development/Flutter/
├── 📁 flutter_starter_kit/   <-- Repo Starter Kit (asal)
└── 📁 my_awesome_app/        <-- Project Baru (hasil generate) ✨
```

*Atau tentukan lokasi khusus via flag `--output`:*
```bash
dart run tool/create_project.dart my_awesome_app --org com.mycompany --output /path/tujuan/my_awesome_app
```

### 🚀 Langkah Selanjutnya:
```bash
cd ../my_awesome_app
dart run build_runner build --delete-conflicting-outputs
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
