import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Centralized app theming for light and dark modes.
///
/// Usage with Bloc:
///   MaterialApp(
///     theme: AppTheme.light,
///     darkTheme: AppTheme.dark,
///     themeMode: state.themeMode, // from your ThemeCubit
///   )
class AppTheme {
  const AppTheme({this.seedColor = const Color(0xFF6750A4)});

  final Color seedColor;

  // Backward-compatible defaults using the default seed
  static final AppTheme _default = const AppTheme();
  static ThemeData get light => _default.lightTheme;
  static ThemeData get dark => _default.darkTheme;

  // Instance-based access using provided seedColor
  ThemeData get lightTheme => _buildTheme(_scheme(Brightness.light));
  ThemeData get darkTheme => _buildTheme(_scheme(Brightness.dark));

  ColorScheme _scheme(Brightness b) =>
      ColorScheme.fromSeed(seedColor: seedColor, brightness: b);

  static ThemeData _buildTheme(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: scheme.brightness,
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: VisualDensity.standard,

      // Typography
      textTheme: _textTheme(scheme),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.outline),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6)),
        labelStyle: TextStyle(color: scheme.onSurface),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),

      // Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),

      // Surfaces & feedback
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1, thickness: 1),

      // Selection & icons
      iconTheme: IconThemeData(color: scheme.onSurface),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.primary,
        selectionColor: scheme.primary.withValues(alpha: 0.35),
        selectionHandleColor: scheme.primary,
      ),

      // Misc controls
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        selectedColor: scheme.primaryContainer,
        disabledColor: scheme.onSurface.withValues(alpha: 0.12),
        labelStyle: TextStyle(color: scheme.onSurface),
        secondaryLabelStyle: TextStyle(color: scheme.onPrimaryContainer),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: scheme.outlineVariant),
        deleteIconColor: scheme.onSurfaceVariant,
        checkmarkColor: scheme.onPrimaryContainer,
        brightness: scheme.brightness,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
        tileColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) ? scheme.primary : scheme.surface;
        }),
        checkColor: WidgetStateProperty.all(scheme.onPrimary),
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) ? scheme.onPrimary : scheme.onSurface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) ? scheme.primary : scheme.surfaceContainerHighest;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.primary.withValues(alpha: 0.24),
        thumbColor: scheme.primary,
        overlayColor: scheme.primary.withValues(alpha: 0.12),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
      ),
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    final base = isDark ? Typography.material2021().white : Typography.material2021().black;
    return base.copyWith(
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.4),
      labelLarge: base.labelLarge?.copyWith(letterSpacing: 0.1),
    );
  }

  /// Convenience helper when you need overlay style directly.
  static SystemUiOverlayStyle systemUiOverlayFor(Brightness b) =>
      b == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
}
