---
trigger: always_on
---

# 📂 Aturan Struktur Keseluruhan Kode (Project Structure)

Setiap penambahan file atau fitur baru di proyek ini WAJIB mematuhi struktur folder dan aturan lokasi berikut:

## 1. Pohon Direktori Utama (`lib/`)

```text
lib/
├── core/                  # Utility global, constants, error handling, theme
│   ├── errors/            # Failure & Exception classes
│   ├── theme/             # AppTheme & ColorScheme
│   ├── usecase/           # UseCase interface dasar
│   └── utils/             # Helper / Extension functions
│
├── data/                  # Implementasi Data & API
│   ├── datasources/       # Sumber Data terklasifikasi
│   │   ├── local/         # Local DataSource (SharedPref, SecureStorage, Sqflite)
│   │   └── remote/        # Remote DataSource (Dio HTTP client, REST API)
│   ├── models/            # DTO / JSON Models (@freezed & json_serializable)
│   │   ├── requests/      # DTO Request Payload API (contoh: login_form_model.dart)
│   │   └── responses/     # DTO Response Payload API (contoh: user_model.dart, cart_model.dart)
│   └── repositories/      # Implementasi dari domain/repositories
│
├── domain/                # Logika Bisnis Murni (Bebas dari import UI & Data)
│   ├── entities/          # Business Model (@freezed)
│   │   ├── requests/      # Entity Form/Request Input UseCase (contoh: login_form.dart)
│   │   ├── responses/     # Entity Response / Output Data Bisnis (contoh: user.dart, cart.dart)
│   │   └── commons/       # Entity Murni UI/Aplikasi (Independen dari API/Data Layer)
│   ├── repositories/      # Repository Interfaces
│   └── usecases/          # Business Logic Execution per Fitur
│       └── <feature>/     # Folder per fitur (contoh: auth/, product/)
│           └── <usecase_name>.dart
│
└── presentation/          # Layar UI & State Management
    ├── bloc/              # BLoC / Cubit State Manager per fitur
    ├── pages/             # Layar UI per Fitur
    │   └── <feature>/     # Folder per fitur (contoh: auth/, camera/)
    │       ├── widgets/   # Widget lokal khusus fitur ini
    │       ├── utils/     # Utility / Helper lokal khusus fitur ini
    │       └── <feature>.dart # Main feature page UI (contoh: auth.dart, camera.dart)
    └── widgets/           # Reusable Global UI Components
```

---

## 2. Matriks Keputusan Lokasi File

| Komponen | Lokasi Folder | Contoh File |
| :--- | :--- | :--- |
| **Main Page UI Fitur** | `lib/presentation/pages/<feature>/` | `lib/presentation/pages/auth/auth.dart` |
| **Widget Spesifik Fitur** | `lib/presentation/pages/<feature>/widgets/` | `lib/presentation/pages/auth/widgets/login_form_widget.dart` |
| **Util Spesifik Fitur** | `lib/presentation/pages/<feature>/utils/` | `lib/presentation/pages/auth/utils/auth_validator.dart` |
| **UseCase Fitur** | `lib/domain/usecases/<feature>/` | `lib/domain/usecases/auth/login.dart` |
| **BLoC / Cubit** | `lib/presentation/bloc/<feature>/` | `lib/presentation/bloc/auth/auth_bloc.dart` |
| **Local DataSource** | `lib/data/datasources/local/` | `lib/data/datasources/local/auth_local_datasource.dart` |
| **Remote DataSource** | `lib/data/datasources/remote/` | `lib/data/datasources/remote/auth_remote_datasource.dart` |
| **Data Model Request** | `lib/data/models/requests/` | `lib/data/models/requests/login_form_model.dart` |
| **Data Model Response** | `lib/data/models/responses/` | `lib/data/models/responses/user_model.dart` |
| **Domain Entity Request** | `lib/domain/entities/requests/` | `lib/domain/entities/requests/login_form.dart` |
| **Domain Entity Response** | `lib/domain/entities/responses/` | `lib/domain/entities/responses/user.dart` |
| **Domain Entity Common (UI)**| `lib/domain/entities/commons/` | `lib/domain/entities/commons/nav_item.dart` |
| **Repository Impl** | `lib/data/repositories/` | `lib/data/repositories/auth_repository_impl.dart` |