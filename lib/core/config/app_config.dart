class AppConfig {
  // API Configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.tronpower.io',
  );

  static const int apiTimeout = int.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: 30000,
  );

  // App Information
  static const String appName = 'TronPower';
  static const String appVersion = '1.0.0';

  // TRON Network Configuration
  static const String tronNetwork = String.fromEnvironment(
    'TRON_NETWORK',
    defaultValue: 'mainnet',
  );

  static const String tronGridApiKey = String.fromEnvironment(
    'TRON_GRID_API_KEY',
    defaultValue: '',
  );

  // Energy Configuration
  static const int minEnergyAmount = 32000;
  static const List<int> popularEnergyAmounts = [65000, 131000, 262000, 524000];

  // Rental Durations (in hours)
  static const List<int> rentalDurations = [1, 24, 72, 360]; // 1h, 1d, 3d, 15d

  // Transaction Fee Configuration
  static const double standardTrxFeePerTransaction = 6.8;
  static const double averageTrxPrice = 0.063; // USD

  // Pagination
  static const int defaultPageSize = 20;

  // Cache Configuration
  static const Duration cacheExpiration = Duration(minutes: 15);

  // WebSocket Configuration
  static const String wsBaseUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'wss://api.tronpower.io/ws',
  );

  // Support
  static const String supportEmail = 'support@tronpower.io';
  static const String websiteUrl = 'https://tronpower.io';
  static const String termsUrl = 'https://tronpower.io/terms';
  static const String privacyUrl = 'https://tronpower.io/privacy';

  // Affiliate Configuration
  static const double affiliateCommissionRate = 0.1; // 10%
  static const int minWithdrawalAmount = 100; // TRX
}
