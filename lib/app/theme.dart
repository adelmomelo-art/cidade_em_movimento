import 'package:flutter/material.dart';

import '../ui/visual_system.dart';

class AppTheme {
  AppTheme._();

  static const blue = GameColors.blue;
  static const yellow = GameColors.yellow;
  static const green = GameColors.green;
  static const red = GameColors.red;

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: GameColors.blue,
      brightness: Brightness.light,
      primary: GameColors.blue,
      secondary: GameColors.orange,
      tertiary: GameColors.green,
      surface: GameColors.white,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: GameColors.cloud,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineLarge: base.textTheme.headlineLarge?.copyWith(
          color: GameColors.ink,
          fontWeight: FontWeight.w900,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          color: GameColors.ink,
          fontWeight: FontWeight.w900,
        ),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          color: GameColors.ink,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          color: GameColors.ink,
          fontWeight: FontWeight.w800,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: GameColors.ink,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GameVisual.radiusMedium),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 0.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GameVisual.radiusSmall),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GameVisual.radiusSmall),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GameVisual.radiusSmall),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GameVisual.radiusSmall),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
      ),
    );
  }
}
