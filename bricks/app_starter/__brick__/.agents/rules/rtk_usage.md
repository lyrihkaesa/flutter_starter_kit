# RTK (Rust Token Killer) Usage Guidelines

## Rule
Setiap kali AI Agent mengeksekusi perintah terminal shell / CLI (seperti `git`, `flutter`, `dart`, `mason`, `build_runner`, dll.), AI WAJIB membungkus perintah tersebut menggunakan `rtk` (Rust Token Killer) untuk mengompresi log output dan menghemat konsumsi token.

## Contoh Perintah:
- `rtk git status`
- `rtk flutter pub get`
- `rtk flutter pub run build_runner build --delete-conflicting-outputs`
- `rtk mason get`
