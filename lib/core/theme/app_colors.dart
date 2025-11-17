import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (TRON Red theme)
  static const Color primary = Color(0xFFE51A31); // TRON Red
  static const Color primaryLight = Color(0xFFFF4D5E);
  static const Color primaryDark = Color(0xFFB01524);

  // Secondary Colors
  static const Color secondary = Color(0xFF1E88E5); // Blue for accents
  static const Color secondaryLight = Color(0xFF64B5F6);
  static const Color secondaryDark = Color(0xFF1565C0);

  // Accent Colors
  static const Color accent = Color(0xFFFFA726); // Orange for highlights
  static const Color accentLight = Color(0xFFFFB74D);
  static const Color accentDark = Color(0xFFFB8C00);

  // Success, Warning, Error
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  static const Color warning = Color(0xFFFFC107);
  static const Color warningLight = Color(0xFFFFD54F);
  static const Color warningDark = Color(0xFFFFA000);

  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFD32F2F);

  // Crypto Specific
  static const Color profit = Color(0xFF00E676); // Green for profits
  static const Color loss = Color(0xFFFF1744); // Red for losses
  static const Color tronRed = Color(0xFFE51A31);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF0A0E27); // Dark blue/purple

  // Surface Colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1F3A);

  // Card Colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF252B49);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFFBDBDBD);

  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  // Input Colors
  static const Color inputBackground = Color(0xFFF9FAFB);
  static const Color inputBackgroundDark = Color(0xFF1F2937);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE51A31), Color(0xFFFF4D5E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient profitGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x40000000);

  // Shimmer Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF1A1F3A);
  static const Color shimmerHighlightDark = Color(0xFF252B49);

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFFE51A31),
    Color(0xFF1E88E5),
    Color(0xFFFFA726),
    Color(0xFF4CAF50),
    Color(0xFF9C27B0),
    Color(0xFF00BCD4),
  ];
}
