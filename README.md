# 🚀 TronPower Flutter Crypto App - Production-Ready Boilerplate

[![Flutter](https://img.shields.io/badge/Flutter-3.8+-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A **production-ready Flutter boilerplate** for crypto applications with custom API integration, built for **Android & iOS**. This project is specifically designed for **TronPower.io** with Node.js backend integration, real-time features, and enterprise-level security.

## ✨ Features

### 🔐 Security & Authentication
- ✅ **Secure Storage** - Encrypted token/key storage using platform Keychain/KeyStore
- ✅ **Biometric Authentication** - Fingerprint & Face ID support
- ✅ **JWT Token Management** - Auto-refresh with retry logic
- ✅ **Session Management** - Persistent login with shared web credentials
- ✅ **Certificate Pinning Ready** - Enhanced API security

### 🌐 API & Network
- ✅ **Dio HTTP Client** - Advanced interceptors (auth, retry, logging)
- ✅ **WebSocket Support** - Real-time price updates and notifications
- ✅ **Auto Token Refresh** - Seamless token renewal on 401 errors
- ✅ **Error Handling** - Comprehensive exception mapping
- ✅ **Network Resilience** - Auto-retry with exponential backoff

### 🏗️ Architecture
- ✅ **Clean Architecture** - Domain/Data/Presentation layers
- ✅ **Dependency Injection** - Injectable + GetIt
- ✅ **State Management** - BLoC pattern with flutter_bloc
- ✅ **Functional Programming** - FPDart with Either for error handling
- ✅ **Code Generation** - Freezed + JSON Serializable

### 💾 Data Persistence
- ✅ **Drift Database** - Offline-first local database
- ✅ **Secure Storage** - Encrypted sensitive data
- ✅ **Shared Preferences** - App settings

### 📱 UI/UX
- ✅ **Material 3 Design** - Modern, responsive UI
- ✅ **Dark/Light Theme** - Persistent theme switching
- ✅ **WebView Integration** - Admin panel access in-app
- ✅ **QR Code** - Scan & generate for wallet addresses
- ✅ **Cached Images** - Optimized image loading

### 🔧 Developer Tools
- ✅ **Sentry Integration** - Production error tracking
- ✅ **Logger** - Beautiful console logging
- ✅ **Mason Bricks** - Code scaffolding
- ✅ **FVM Support** - Flutter version management

---

## 📋 Prerequisites

- **Flutter SDK**: 3.8.0 or higher
- **Dart SDK**: 3.8.0 or higher
- **FVM** (recommended): [Installation Guide](https://fvm.app/docs/getting_started/installation)
- **Node.js Backend**: Running TronPower API
- **Neon PostgreSQL**: Backend database

---

## 🚀 Quick Start

### 1. Clone Repository

```bash
git clone <your-repo-url>
cd flutter_project
```

### 2. Setup Flutter Version (with FVM)

```bash
# Install FVM if not already installed
dart pub global activate fvm

# Use project Flutter version (3.32.5)
fvm use

# Verify installation
fvm flutter --version
```

> **Windows Users**: Enable "Developer Mode" in Windows Settings for symlink support.

### 3. Configure Environment Variables

The `.env` file is already created. Update it with your API URLs:

```bash
# Edit .env file
APP_NAME="TronPower"
API_URL=https://api.tronpower.io
WS_URL=wss://api.tronpower.io
ADMIN_PANEL_URL=https://admin.tronpower.io
ENVIRONMENT=development
API_TIMEOUT=30000
ENABLE_API_LOGGING=true
SENTRY_DSN=  # Optional: Add your Sentry DSN for error tracking
```

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Generate Code (Freezed, JSON, Injectable)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- Freezed models (`.freezed.dart`)
- JSON serialization (`.g.dart`)
- Injectable dependency injection (`injection.config.dart`)

### 6. Setup Mason Bricks (Optional)

```bash
# Install Mason CLI
dart pub global activate mason_cli

# Get bricks
mason get
```

Available bricks:
- `remote_datasource` - Generate API data sources
- `local_datasource` - Generate local data sources
- `model` - Generate data models
- `entity` - Generate domain entities
- `repository` - Generate repositories
- `usecase` - Generate use cases
- `bloc` - Generate BLoC state management

### 7. Run the App

```bash
# Development mode
flutter run

# Or with FVM
fvm flutter run

# Select device (Android/iOS)
```

---

## 🏗️ Project Structure

```
lib/
├── core/                          # Core utilities
│   ├── app_config.dart           # Environment configuration
│   ├── errors/                   # Error handling
│   │   ├── exception.dart        # Custom exceptions
│   │   └── failure.dart          # Failure types (Freezed)
│   ├── network/                  # Network layer
│   │   └── dio_interceptor.dart  # Dio interceptors (Auth, Retry, etc.)
│   ├── services/                 # Core services
│   │   ├── biometric_service.dart      # Biometric auth
│   │   ├── secure_storage_service.dart # Encrypted storage
│   │   └── websocket_service.dart      # Real-time connection
│   └── themes/                   # App theming
│       └── app_theme.dart        # Material 3 themes
│
├── data/                         # Data layer (Clean Architecture)
│   ├── datasources/
│   │   ├── local/               # Local data sources
│   │   │   ├── auth_local_data_source.dart
│   │   │   └── app_theme_local_data_source.dart
│   │   └── remote/              # API data sources
│   │       └── auth_remote_data_source.dart
│   ├── models/                  # Data models (with JSON)
│   │   ├── auth_token_model.dart
│   │   ├── user_model.dart
│   │   └── response_model.dart
│   └── repositories_impl/       # Repository implementations
│       ├── auth_repository_impl.dart
│       └── app_theme_repository_impl.dart
│
├── domain/                      # Domain layer (Business logic)
│   ├── entities/               # Domain entities
│   │   ├── user.dart
│   │   ├── auth_token.dart
│   │   ├── wallet.dart
│   │   ├── transaction.dart
│   │   └── response.dart
│   ├── repositories/           # Repository interfaces
│   │   ├── auth_repository.dart
│   │   └── app_theme_repository.dart
│   └── usecases/               # Use cases (business rules)
│       └── theme/
│           ├── load_theme.dart
│           └── save_theme.dart
│
├── presentation/               # Presentation layer
│   ├── bloc/                  # BLoC state management
│   │   └── app_theme/
│   │       ├── app_theme_bloc.dart
│   │       ├── app_theme_event.dart
│   │       └── app_theme_state.dart
│   └── pages/                 # UI pages
│       ├── auth/
│       │   ├── login_page.dart
│       │   └── register_page.dart
│       ├── admin_panel_page.dart  # WebView admin panel
│       ├── home_page.dart
│       ├── profile_page.dart
│       └── errors/
│           └── not_found_page.dart
│
├── router/                    # Navigation
│   ├── app_router.dart       # Route definitions
│   ├── router.dart           # GoRouter configuration
│   └── router_item.dart      # Route item model
│
├── injection.dart            # Dependency injection setup
├── app.dart                  # App widget
└── main.dart                 # Entry point with Sentry
```

---

## 🔐 Authentication Flow

### Login Process

1. User enters email/password
2. App calls `/auth/login` endpoint
3. Backend returns JWT tokens + user data
4. Tokens saved to **Secure Storage** (encrypted)
5. User data saved to **SharedPreferences**
6. Navigate to home page

### Token Refresh (Automatic)

1. API request returns **401 Unauthorized**
2. `TokenRefreshInterceptor` catches error
3. Calls `/auth/refresh` with refresh token
4. New tokens saved automatically
5. Original request retried with new token

### Shared Web/App Login

- Same email/password works on both web and app
- Backend manages user sessions
- JWT tokens work across platforms

---

## 🌐 API Integration Guide

### Endpoints Expected

Your Node.js backend should provide these endpoints:

```javascript
// Authentication
POST   /auth/login           // Login
POST   /auth/register        // Register
POST   /auth/logout          // Logout
POST   /auth/refresh         // Refresh token
GET    /auth/me              // Get current user
PUT    /auth/profile         // Update profile
POST   /auth/verify-email    // Verify email
POST   /auth/forgot-password // Request password reset
POST   /auth/reset-password  // Reset password
```

### Request/Response Format

**Login Request:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Login Response:**
```json
{
  "token": {
    "access_token": "eyJhbGc...",
    "refresh_token": "eyJhbGc...",
    "token_type": "Bearer",
    "expires_in": 3600
  },
  "user": {
    "id": "user-uuid",
    "email": "user@example.com",
    "name": "John Doe",
    "wallet_address": "T...",
    "is_verified": true,
    "is_active": true,
    "created_at": "2024-01-01T00:00:00Z"
  }
}
```

---

## 🔌 WebSocket Integration

### Connect to Real-Time Updates

```dart
// In your service or BLoC
final wsService = getIt<WebSocketService>();

// Connect
await wsService.connect();

// Subscribe to events
wsService.subscribe('price_updates', params: {'currency': 'TRX'});

// Listen to messages
wsService.messageStream.listen((message) {
  print('Received: $message');
});

// Unsubscribe
wsService.unsubscribe('price_updates');

// Disconnect
wsService.disconnect();
```

---

## 📱 Admin Panel Integration

The admin panel from tronpower.io is integrated via WebView:

```dart
// Navigate to admin panel
context.go('/admin');

// Or programmatically
context.goNamed(AppRouter.adminPanel.name);
```

The WebView loads your existing admin panel URL from `.env`:
```
ADMIN_PANEL_URL=https://admin.tronpower.io
```

---

## 🔒 Security Best Practices

### ✅ Implemented

1. **Encrypted Storage** - All tokens/keys use platform-native encryption
2. **Biometric Auth** - Optional fingerprint/Face ID
3. **Token Auto-Refresh** - Prevents session expiration
4. **Retry Logic** - Network resilience with exponential backoff
5. **Error Tracking** - Sentry integration for production monitoring

### 🚧 Recommended Additions

1. **Certificate Pinning** - Pin your API SSL certificate
   ```dart
   // In dio configuration (injection.dart)
   // Add certificate pinning interceptor
   ```

2. **Obfuscation** - Obfuscate release builds
   ```bash
   flutter build apk --obfuscate --split-debug-info=build/debug-info
   ```

3. **ProGuard** - Enable for Android in `android/app/build.gradle`

---

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

---

## 📦 Building for Production

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# With obfuscation
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
```

### iOS

```bash
# Build iOS
flutter build ios --release

# Archive for App Store
# Use Xcode -> Product -> Archive
```

---

## 🛠️ Development Workflow

### 1. Code Generation (Auto-watch)

```bash
# Watch for changes and auto-generate
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 2. Create New Features with Mason

```bash
# Example: Create a new BLoC
mason make bloc --name wallet

# Create a new repository
mason make repository --name wallet
```

### 3. Logging

```dart
// Use the injected Logger
final logger = getIt<Logger>();

logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message');
```

---

## 🤝 Integration with Your Backend

### Environment Setup

1. Update `.env` with your API URLs
2. Ensure your Node.js backend is running
3. Configure CORS to allow Flutter app requests
4. Set up JWT token generation/validation
5. Connect to Neon PostgreSQL

### Backend Requirements Checklist

- [ ] User authentication endpoints
- [ ] JWT token generation
- [ ] Refresh token mechanism
- [ ] WebSocket server for real-time updates
- [ ] CORS configuration
- [ ] Error response formatting matches `ResponseModel`

---

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Freezed Package](https://pub.dev/packages/freezed)
- [Injectable](https://pub.dev/packages/injectable)

---

## 🐛 Troubleshooting

### Issue: Build runner fails

```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Dependency conflicts

```bash
# Update dependencies
flutter pub upgrade --major-versions
```

### Issue: FVM not working

```bash
# Reinstall FVM
dart pub global deactivate fvm
dart pub global activate fvm
```

---

## 📄 License

This project is licensed under the MIT License.

---

## 👨‍💻 Author

Built for **TronPower.io** - Enterprise Flutter Crypto App

**Stack:**
- Flutter 3.8+
- Node.js Backend
- Neon PostgreSQL
- Real-time WebSocket
- JWT Authentication

---

## 🎯 Next Steps

1. ✅ Clone and set up the project
2. ✅ Configure `.env` with your API URLs
3. ✅ Run `flutter pub get`
4. ✅ Run `build_runner` to generate code
5. ✅ Connect to your Node.js backend
6. ✅ Test authentication flow
7. ✅ Customize UI/theme as needed
8. ✅ Add your crypto-specific features
9. ✅ Deploy to production

**Happy Coding! 🚀**
