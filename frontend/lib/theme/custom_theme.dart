import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return FlexThemeData.light(
      scheme: FlexScheme.damask,
    );
  }

  static ThemeData get darkTheme {
    return FlexThemeData.dark(
      scheme: FlexScheme.damask,
    );
  }
}
