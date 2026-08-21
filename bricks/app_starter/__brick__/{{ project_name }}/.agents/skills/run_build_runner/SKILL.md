---
name: run-build-runner
description: Runbook untuk menjalankan build_runner guna menyelaraskan kode hasil kompilasi Freezed, JSON Serializable, dan Injectable.
---

# 🛠️ Runbook Regenerasi Kode (build_runner)

Jalankan perintah ini setiap kali Anda:
1. Menambah/mengubah file `@freezed` (Entity, Model, atau State).
2. Menambah/mengubah anotasi `@injectable`, `@lazySingleton`, atau `@singleton`.
3. Menambah/mengubah anotasi `@JsonSerializable`.

## Perintah Eksekusi

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Jika dalam mode development intensif dan ingin watch mode:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```
