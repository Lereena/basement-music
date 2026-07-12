/// Animation duration scale for the app.
abstract final class AppDurations {
  /// 100ms — micro feedback: hover, pressed states.
  static const Duration fast = Duration(milliseconds: 100);

  /// 200ms — default: fades, small movements, highlight changes.
  static const Duration normal = Duration(milliseconds: 200);

  /// 350ms — larger transitions: sheets, expanding panels.
  static const Duration slow = Duration(milliseconds: 350);
}
