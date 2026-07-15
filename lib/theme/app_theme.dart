import 'package:flutter/material.dart';

/// Korva Engine's visual identity: dark graphite surfaces with a warm
/// brass accent and monospaced "telemetry" data — a precision-instrument
/// feel, deliberately distinct from the generic dark-mode-plus-neon-accent
/// look common to AI-generated app UIs.
class AppColors {
  AppColors._();

  static const background = Color(0xFF0B0C0E);
  static const surface = Color(0xFF15171B);
  static const surfaceElevated = Color(0xFF1D2024);
  static const hairline = Color(0xFF2A2D33);

  static const brass = Color(0xFFC9A15A);
  static const brassDeep = Color(0xFFA9814A);
  static const steel = Color(0xFF7C838F);
  static const steelSurface = Color(0xFF21242A);

  static const textPrimary = Color(0xFFF2F1ED);
  static const textSecondary = Color(0xFF9A9DA6);
  static const textMuted = Color(0xFF686C74);

  static const signalGreen = Color(0xFF6FCF97);
  static const signalRed = Color(0xFFE2685B);

  static const onBrass = Color(0xFF201A0E);
}

class AppTheme {
  AppTheme._();

  static const _monoFontFamily = 'monospace';

  static ThemeData get dark {
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);

    final colorScheme = base.colorScheme.copyWith(
      brightness: Brightness.dark,
      primary: AppColors.brass,
      onPrimary: AppColors.onBrass,
      secondary: AppColors.steel,
      onSecondary: AppColors.textPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.signalRed,
      onError: Colors.white,
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.hairline,
      splashFactory: InkRipple.splashFactory,
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 20),
      cardTheme: CardThemeData(
        color: AppColors.surfaceElevated,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.hairline),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brass,
          foregroundColor: AppColors.onBrass,
          disabledBackgroundColor: AppColors.brass.withValues(alpha: 0.35),
          disabledForegroundColor: AppColors.onBrass.withValues(alpha: 0.6),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          backgroundColor: AppColors.steelSurface,
          disabledForegroundColor: AppColors.textMuted,
          side: const BorderSide(color: AppColors.hairline),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.brass, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.signalRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.signalRed, width: 1.4),
        ),
        errorStyle: const TextStyle(color: AppColors.signalRed, fontSize: 12),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.hairline),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.brass),
    );
  }

  /// Small-caps-style "eyebrow" label used for section titles such as
  /// RECENT PROJECTS — the recurring signature of the instrument-panel
  /// motif carried through headers, the status bar, and dialogs.
  static TextStyle eyebrow({Color color = AppColors.textSecondary}) {
    return TextStyle(
      fontSize: 12.5,
      fontWeight: FontWeight.w700,
      letterSpacing: 2.2,
      color: color,
    );
  }

  /// Monospace treatment used for paths, dates, and other "telemetry"
  /// read-outs, reinforcing the precision-tool feel.
  static TextStyle mono({
    double fontSize = 12.5,
    Color color = AppColors.textSecondary,
    FontWeight weight = FontWeight.w500,
  }) {
    return TextStyle(
      fontFamily: _monoFontFamily,
      fontSize: fontSize,
      color: color,
      fontWeight: weight,
      letterSpacing: 0.1,
    );
  }
}
