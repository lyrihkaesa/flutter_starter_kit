// Storage Keys
class StorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String theme = 'theme';
  static const String language = 'language';
  static const String biometricEnabled = 'biometric_enabled';
  static const String walletAddress = 'wallet_address';
  static const String walletPrivateKey = 'wallet_private_key';
  static const String isFirstLaunch = 'is_first_launch';
}

// API Endpoints
class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // User
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';

  // Energy
  static const String energyPackages = '/energy/packages';
  static const String quickBuy = '/energy/quick-buy';
  static const String rentEnergy = '/energy/rent';
  static const String energyHistory = '/energy/history';
  static const String energyBalance = '/energy/balance';
  static const String calculateEnergy = '/energy/calculate';

  // Transactions
  static const String transactions = '/transactions';
  static const String transactionDetails = '/transactions/:id';
  static const String transactionStatus = '/transactions/:id/status';

  // Wallet
  static const String walletBalance = '/wallet/balance';
  static const String walletHistory = '/wallet/history';
  static const String walletConnect = '/wallet/connect';

  // Affiliate
  static const String affiliateStats = '/affiliate/stats';
  static const String affiliateReferrals = '/affiliate/referrals';
  static const String affiliateEarnings = '/affiliate/earnings';
  static const String affiliateWithdraw = '/affiliate/withdraw';
  static const String generateReferralCode = '/affiliate/generate-code';

  // Calculator
  static const String calculateFees = '/calculator/fees';
  static const String savingsEstimate = '/calculator/savings';

  // Support
  static const String supportTickets = '/support/tickets';
  static const String createTicket = '/support/tickets';
  static const String faq = '/support/faq';

  // Services
  static const String services = '/services';
  static const String nodeService = '/services/node';
  static const String botService = '/services/bot';
  static const String flashEnergy = '/services/flash-energy';
}

// Enums
enum EnergyDuration {
  oneHour(1, '1 Hour'),
  oneDay(24, '1 Day'),
  threeDays(72, '3 Days'),
  fifteenDays(360, '15 Days');

  final int hours;
  final String label;

  const EnergyDuration(this.hours, this.label);

  static EnergyDuration fromHours(int hours) {
    return values.firstWhere(
      (duration) => duration.hours == hours,
      orElse: () => oneHour,
    );
  }
}

enum TransactionStatus {
  pending('Pending'),
  processing('Processing'),
  completed('Completed'),
  failed('Failed'),
  cancelled('Cancelled');

  final String label;

  const TransactionStatus(this.label);
}

enum TransactionType {
  energyRental('Energy Rental'),
  energyRefill('Energy Refill'),
  withdrawal('Withdrawal'),
  deposit('Deposit'),
  affiliate('Affiliate Commission');

  final String label;

  const TransactionType(this.label);
}

enum ServiceType {
  quickEnergy('Quick Energy', 'Instant energy delivery for your transactions'),
  affiliate('Affiliate', 'Earn commissions by referring new users'),
  support('Support', '24/7 customer support and assistance'),
  nodeService('Node Service', 'Enterprise-grade TRON node infrastructure'),
  botService('Bot Service', 'Custom Telegram bots without coding'),
  webServices('Web Services', 'Complete website solutions and tools'),
  flashEnergy('Flash Energy', 'Lightning-fast energy recovery'),
  other('Other Services', 'Additional blockchain and web solutions');

  final String title;
  final String description;

  const ServiceType(this.title, this.description);
}

// Animation Durations
class AnimationDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}

// App Dimensions
class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
}

// Regular Expressions
class AppRegex {
  static final RegExp email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp tronAddress = RegExp(
    r'^T[a-zA-Z0-9]{33}$',
  );

  static final RegExp password = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$',
  );
}
