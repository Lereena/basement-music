import 'package:basement_music/theme/app_radius.dart';
import 'package:basement_music/theme/app_semantic_colors.dart';
import 'package:basement_music/theme/app_typography.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

/// App theme built on the damask FlexColorScheme palette (terracotta primary,
/// sage secondary/tertiary).
///
/// The exact damask primary is kept as brand color while the rest of the
/// scheme is seeded into full Material 3 tonal palettes, giving harmonized
/// containers and surface tints in both modes.
class CustomTheme {
  static ThemeData get lightTheme {
    return FlexThemeData.light(
      scheme: FlexScheme.damask,
      appBarStyle: FlexAppBarStyle.scaffoldBackground,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 2,
      keyColors: _keyColors,
      subThemesData: _subThemesData,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      textTheme: AppTypography.textTheme,
      extensions: const [AppSemanticColors.light],
    );
  }

  static ThemeData get darkTheme {
    return FlexThemeData.dark(
      scheme: FlexScheme.damask,
      appBarStyle: FlexAppBarStyle.scaffoldBackground,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 8,
      keyColors: _keyColors,
      subThemesData: _subThemesData,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      textTheme: AppTypography.textTheme,
      extensions: const [AppSemanticColors.dark],
    );
  }

  /// Seed M3 tonal palettes from the damask key colors, but pin the primary
  /// so the brand terracotta stays exact.
  static const _keyColors = FlexKeyColors(useSecondary: true, useTertiary: true, keepPrimary: true);

  /// Component styling shared by both modes. Radii mirror [AppRadius] so
  /// custom-drawn containers match themed Material components.
  static const _subThemesData = FlexSubThemesData(
    interactionEffects: true,
    tintedDisabledControls: true,
    defaultRadius: AppRadius.md,
    cardRadius: AppRadius.lg,
    dialogRadius: AppRadius.xl,
    bottomSheetRadius: AppRadius.xl,
    chipRadius: AppRadius.sm,
    popupMenuRadius: AppRadius.sm,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorIsFilled: true,
    inputDecoratorRadius: AppRadius.md,
    inputDecoratorUnfocusedHasBorder: false,
    fabUseShape: true,
    fabRadius: AppRadius.lg,
    snackBarRadius: AppRadius.sm,
    navigationBarIndicatorOpacity: 1,
    navigationRailIndicatorOpacity: 1,
  );
}
