import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // ─── Primary: Espresso Brown ──────────────────────────────────────
  static const primary = Color(0xFF2C1810); // Deep Espresso
  static const primaryLight = Color(0xFF4A2C1E); // Warm Brown
  static const primaryDark = Color(0xFF1A0F09); // Very Dark Roast
  static const primarySurface = Color(0xFFF5EDE8); // Espresso Tint

  // ─── Secondary: Cafe Gold / Bronze ────────────────────────────────
  static const secondary = Color(0xFFC9A84C); // Cafe Gold
  static const secondaryLight = Color(0xFFE4C875); // Light Gold
  static const secondaryDark = Color(0xFF9E7A28); // Deep Bronze
  static const secondarySurface = Color(0xFFFBF5E6); // Gold Tint

  // ─── Background: Warm Cream / Latte ───────────────────────────────
  static const background = Color(0xFFF9F4EF); // Warm Cream
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF2EBE3); // Latte Tint
  static const surfaceCard = Color(0xFFFEFAF7); // Off-white warm

  // ─── Sidebar: Dark Roast ──────────────────────────────────────────
  static const sidebarBg = Color(0xFF1A0F09); // Dark Roast
  static const sidebarHover = Color(0xFF2C1810); // Espresso
  static const sidebarActive = Color(0xFFC9A84C); // Gold active
  static const sidebarText = Color(0xFFD4B896); // Warm tan
  static const sidebarTextActive = Color(0xFFFFFFFF);
  static const sidebarDivider = Color(0xFF3D2416);

  // ─── Status Colors ────────────────────────────────────────────────
  static const success = Color(0xFF2D7A4F);
  static const successSurface = Color(0xFFEAF5EE);
  static const warning = Color(0xFFC9A84C); // Gold = warning
  static const warningSurface = Color(0xFFFBF5E6);
  static const error = Color(0xFFB04040);
  static const errorSurface = Color(0xFFF9EAEA);
  static const info = Color(0xFF4A708A);
  static const infoSurface = Color(0xFFEAF2F7);

  // ─── Text ─────────────────────────────────────────────────────────
  static const textPrimary = Color(0xFF1E1108); // Near-black warm
  static const textSecondary = Color(0xFF5C4A3A); // Warm brown-grey
  static const textMuted = Color(0xFF9E8878); // Muted mocha
  static const textOnDark = Color(0xFFF5EDE8); // Light cream for dark bg
  static const textGold = Color(0xFFC9A84C); // Gold accent text

  // ─── Borders ──────────────────────────────────────────────────────
  static const border = Color(0xFFE8D9CC);
  static const borderFocus = Color(0xFFC9A84C); // Gold focus
  static const divider = Color(0xFFF0E4DA);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primarySurface,
        onPrimaryContainer: AppColors.primary,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.secondarySurface,
        onSecondaryContainer: AppColors.secondaryDark,
        tertiary: AppColors.secondaryLight,
        onTertiary: AppColors.primaryDark,
        tertiaryContainer: AppColors.secondarySurface,
        onTertiaryContainer: AppColors.secondaryDark,
        error: AppColors.error,
        onError: Colors.white,
        errorContainer: AppColors.errorSurface,
        onErrorContainer: AppColors.error,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.border,
        outlineVariant: AppColors.divider,
        shadow: AppColors.primaryDark,
        scrim: AppColors.primaryDark,
        inverseSurface: AppColors.primaryDark,
        onInverseSurface: AppColors.textOnDark,
        inversePrimary: AppColors.secondaryLight,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.cormorantGaramondTextTheme().copyWith(
        displayLarge: GoogleFonts.cormorantGaramond(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.cormorantGaramond(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineLarge: GoogleFonts.cormorantGaramond(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.cormorantGaramond(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineSmall: GoogleFonts.cormorantGaramond(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.1,
        ),
        titleMedium: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        titleSmall: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textMuted,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.3,
        ),
        labelMedium: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
          letterSpacing: 0.8,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceCard,
        elevation: 0,
        shadowColor: AppColors.primaryDark.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondary,
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderFocus, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: GoogleFonts.outfit(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.outfit(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primarySurface,
        labelStyle: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.primaryDark.withOpacity(0.05),
        titleTextStyle: GoogleFonts.cormorantGaramond(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        centerTitle: false,
      ),
    );
  }
}
