# Kaesa Flutter Starter Kit

## 🚀 Instalasi dengan FVM

Project ini menggunakan [FVM](https://fvm.app/) untuk mengatur versi Flutter.

### 1. Clone repository

```bash
git clone https://github.com/lyrihkaesa/flutter_starter_kit.git
cd flutter_starter_kit
```

### 2. Setup environment

Salin file contoh environment:

```bash
cp .env.example .env
```

### 3. Gunakan Flutter versi project

Pastikan sudah install [FVM](https://fvm.app/docs/getting_started/installation).
Lalu jalankan:

```bash
fvm use
```

Ini akan membaca `.fvmrc` dan mengatur Flutter versi **3.32.5** sesuai project.

> ⚠️ **Windows user**:
>
> - Restart VSCode setelah `fvm use`.
> - Pastikan **Flutter SDK path** di VSCode diarahkan ke `.fvm/flutter_sdk`.
> - Aktifkan "Development Mode" di Windows agar symlink FVM bisa bekerja.

### 4. Install dependencies

Setelah `fvm use` dan restart editor vscode `CTRL + SHIFT + P` cari `> Developer: Reload Window`, setelah itu jalankan:

```bash
flutter pub get
```

### 5. Build Freezed

Generate file yang diperlukan Freezed:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 6. Setup Mason bricks

Project ini menggunakan [Mason](https://pub.dev/packages/mason_cli) untuk scaffold code.
Jalankan perintah berikut agar bricks bisa di-load:

```bash
mason get
```

Repository bricks yang digunakan:
👉 [bricks_flutter_starter_kit](https://github.com/lyrihkaesa/bricks_flutter_starter_kit)

### 7. Menjalankan project

```bash
flutter run
```

---

## 💡 Tips

- Gunakan perintah `flutter` biasa setelah `fvm use` (bukan `fvm flutter`) agar konsisten dengan SDK project.
- Gunakan `flutter pub run build_runner watch --delete-conflicting-outputs` saat development untuk regenerasi otomatis Freezed.
- Gunakan `mason make <brick_name>` untuk membuat template dari bricks yang sudah tersedia.
