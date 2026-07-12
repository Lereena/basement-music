/// Spacing scale for the app, based on a 4dp grid.
///
/// Use these instead of hardcoded padding/gap values so layouts stay
/// consistent across pages and widgets.
abstract final class AppSpacing {
  /// 2 — hairline gaps (icon-to-label inside compact rows).
  static const double xxs = 2;

  /// 4 — tight gaps between related elements.
  static const double xs = 4;

  /// 8 — default gap between elements in a row/column.
  static const double sm = 8;

  /// 12 — comfortable gap between grouped elements.
  static const double md = 12;

  /// 16 — default page/card padding.
  static const double lg = 16;

  /// 24 — separation between sections.
  static const double xl = 24;

  /// 32 — large section separation.
  static const double xxl = 32;

  /// 48 — hero/empty-state breathing room.
  static const double xxxl = 48;
}
