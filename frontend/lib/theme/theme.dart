/// Design system entry point: import this file to get the theme, all tokens
/// and the `BuildContext` shortcuts.
library;

import 'package:basement_music/theme/app_semantic_colors.dart';
import 'package:flutter/material.dart';

export 'package:basement_music/theme/app_durations.dart';
export 'package:basement_music/theme/app_radius.dart';
export 'package:basement_music/theme/app_semantic_colors.dart';
export 'package:basement_music/theme/app_spacing.dart';
export 'package:basement_music/theme/app_typography.dart';
export 'package:basement_music/theme/custom_theme.dart';

extension ThemeContextX on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  AppSemanticColors get semanticColors => Theme.of(this).extension<AppSemanticColors>()!;
}
