import 'package:flutter/material.dart';

/// Semantic colors that Material's [ColorScheme] does not cover, harmonized
/// with the damask palette (terracotta primary, sage secondary/tertiary).
///
/// Access via `Theme.of(context).extension<AppSemanticColors>()!` or the
/// `context.semanticColors` shortcut from `theme.dart`.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  /// Positive states: successful upload, cached track, saved changes.
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  /// Cautionary states: degraded connectivity, pending sync.
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  /// Favourite (heart) accent.
  final Color favourite;

  /// Background highlight for the currently playing track row.
  final Color nowPlayingHighlight;

  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.favourite,
    required this.nowPlayingHighlight,
  });

  static const light = AppSemanticColors(
    success: Color(0xFF3E7B4F),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFC5E8CC),
    onSuccessContainer: Color(0xFF0E2915),
    warning: Color(0xFF9A6A18),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFF6E0B8),
    onWarningContainer: Color(0xFF2E2000),
    favourite: Color(0xFFC6455C),
    // Damask light primary (#C96646) at 10% opacity.
    nowPlayingHighlight: Color(0x1AC96646),
  );

  static const dark = AppSemanticColors(
    success: Color(0xFF8FC79A),
    onSuccess: Color(0xFF12351C),
    successContainer: Color(0xFF2B4D34),
    onSuccessContainer: Color(0xFFC5E8CC),
    warning: Color(0xFFE3BC66),
    onWarning: Color(0xFF3A2B00),
    warningContainer: Color(0xFF5C4712),
    onWarningContainer: Color(0xFFF6E0B8),
    favourite: Color(0xFFE2899A),
    // Damask dark primary (#DA9882) at 12% opacity.
    nowPlayingHighlight: Color(0x1FDA9882),
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? favourite,
    Color? nowPlayingHighlight,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      favourite: favourite ?? this.favourite,
      nowPlayingHighlight: nowPlayingHighlight ?? this.nowPlayingHighlight,
    );
  }

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other == null) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      favourite: Color.lerp(favourite, other.favourite, t)!,
      nowPlayingHighlight: Color.lerp(nowPlayingHighlight, other.nowPlayingHighlight, t)!,
    );
  }
}
