# 🎨 Pedoman Kode & Kualitas UI

## 1. Linting & Quality
- **DILARANG** menggunakan `print()`. Gunakan logger profesional atau mixin `DevLog`.
- Selalu periksa warning lint dengan `flutter analyze`.

## 2. UI & Design System
- Gunakan `ColorScheme` dari tema global aplikasi (`Theme.of(context).colorScheme`).
- Hindari warna atau ukuran font yang *hardcoded*.
- Pastikan tampilan responsif dan dapat menyesuaikan berbagai ukuran layar.
