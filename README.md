# TronPower Mobile App

Save TRX on Every Transaction. Rent energy and reduce transaction fees by up to 95%.

## Features

- 🔐 **Authentication** - Login/Signup with existing TronPower accounts
- ⚡ **Quick Buy Energy** - Purchase energy instantly without registration
- 📦 **Energy Packages** - Multiple rental durations (1h, 1d, 3d, 15d)
- 🧮 **Fee Calculator** - Calculate savings vs. burning TRX
- 💼 **Wallet Integration** - TRON wallet support
- 🤝 **Affiliate System** - Earn commissions by referring users
- 📊 **Transaction History** - Track all your energy rentals
- 🔔 **Real-time Notifications** - Energy delivery updates
- 🌙 **Dark/Light Theme** - Customizable appearance

## Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: flutter_bloc
- **Architecture**: Clean Architecture (Presentation, Domain, Data)
- **API**: Dio + Retrofit
- **Database**: Neon PostgreSQL (via API)
- **Blockchain**: web3dart for TRON integration
- **DI**: get_it + injectable
- **Routing**: go_router
- **Local Storage**: Hive + Shared Preferences

## Project Structure

```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── constants/       # Constants & enums
│   ├── errors/          # Error handling
│   ├── network/         # API client setup
│   ├── theme/           # App theming
│   └── utils/           # Utility functions
├── features/
│   ├── auth/            # Authentication
│   ├── energy/          # Energy rental
│   ├── calculator/      # Fee calculator
│   ├── affiliate/       # Affiliate system
│   ├── transactions/    # Transaction history
│   ├── wallet/          # TRON wallet
│   └── profile/         # User profile
├── shared/
│   └── widgets/         # Reusable widgets
└── main.dart
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.2.0)
- Dart SDK
- Node.js backend running
- Neon database configured

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd tronpower
```

2. Install dependencies
```bash
flutter pub get
```

3. Create `.env` file
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. Run code generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

5. Run the app
```bash
flutter run
```

## API Integration

The app integrates with TronPower Node.js backend via REST API:

- Base URL: `https://api.tronpower.io`
- Authentication: JWT tokens stored securely
- Real-time updates: WebSocket connections

## Building for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## License

This project is proprietary software owned by TronPower.

## Support

For support, email support@tronpower.io or visit our website at https://tronpower.io
