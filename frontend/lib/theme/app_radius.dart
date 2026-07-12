import 'package:flutter/widgets.dart';

/// Corner radius scale for the app.
///
/// Matches the radii configured in [FlexSubThemesData] inside CustomTheme, so
/// custom-drawn containers line up with themed Material components.
abstract final class AppRadius {
  /// 8 — small elements: chips, thumbnails, inline tags.
  static const double sm = 8;

  /// 12 — default: buttons, inputs, list tiles, covers.
  static const double md = 12;

  /// 16 — cards and larger surfaces.
  static const double lg = 16;

  /// 20 — dialogs and bottom sheets.
  static const double xl = 20;

  /// Fully rounded (pills, circular avatars).
  static const double full = 999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius fullAll = BorderRadius.all(Radius.circular(full));
}
