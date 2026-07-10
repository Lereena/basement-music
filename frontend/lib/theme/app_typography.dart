import 'package:flutter/material.dart';

/// Typography adjustments layered on top of Material 2021 defaults.
///
/// Colors are left null so FlexColorScheme applies scheme-appropriate ones;
/// only weights, sizes and spacing are pinned here.
abstract final class AppTypography {
  static const TextTheme textTheme = TextTheme(
    // Page and section titles: slightly tighter and heavier than M3 defaults
    // for a more contemporary feel.
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.25),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.15),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    // Body: track names, artist lines, descriptions.
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.4),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.4),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.35),
    // Labels: buttons, chips, metadata like track duration.
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.2),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3),
  );
}
