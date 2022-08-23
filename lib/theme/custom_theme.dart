import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get generatedTheme {
    return ThemeData(
      colorScheme: const ColorScheme(
        background: Color(0xfffcfcfc),
        error: Color(0xffba1b1b),
        errorContainer: Color(0xffffdad4),
        inversePrimary: Color(0xffffb49d),
        inverseSurface: Color(0xff362f2d),
        onBackground: Color(0xff211a18),
        onError: Color(0xffffffff),
        onErrorContainer: Color(0xff410001),
        onInverseSurface: Color(0xfffbeeeb),
        onPrimary: Color(0xffffffff),
        onPrimaryContainer: Color(0xff3b0900),
        onSecondary: Color(0xffffffff),
        onSecondaryContainer: Color(0xff2c150e),
        onSurface: Color(0xff211a18),
        onSurfaceVariant: Color(0xff53433f),
        onTertiary: Color(0xffffffff),
        onTertiaryContainer: Color(0xff231b00),
        outline: Color(0xff85736e),
        primary: Color(0xffac3509),
        primaryContainer: Color(0xffffdbcf),
        secondary: Color(0xff77574d),
        secondaryContainer: Color(0xffffdbcf),
        shadow: Color(0xff000000),
        surface: Color(0xfffcfcfc),
        surfaceTint: Color(0xffac3509),
        surfaceVariant: Color(0xfff5ded8),
        tertiary: Color(0xff6b5d2e),
        tertiaryContainer: Color(0xfff5e2a7),
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData get generatedDarkTheme {
    return ThemeData(
      colorScheme: const ColorScheme(
        background: Color(0xff201a18),
        error: Color(0xffffb4a9),
        errorContainer: Color(0xff930006),
        inversePrimary: Color(0xffb22d00),
        inverseSurface: Color(0xffede0dd),
        onBackground: Color(0xffede0dd),
        onError: Color(0xff680003),
        onErrorContainer: Color(0xffffb4a9),
        onInverseSurface: Color(0xff362f2d),
        onPrimary: Color(0xff601400),
        onPrimaryContainer: Color(0xffffdacf),
        onSecondary: Color(0xff442a22),
        onSecondaryContainer: Color(0xffffdacf),
        onSurface: Color(0xffede0dd),
        onSurfaceVariant: Color(0xffd8c2bc),
        onTertiary: Color(0xff3a2f04),
        onTertiaryContainer: Color(0xfff5e1a6),
        outline: Color(0xffa08c87),
        primary: Color(0xffffb49d),
        primaryContainer: Color(0xff882000),
        secondary: Color(0xffe7bdb2),
        secondaryContainer: Color(0xff5d3f37),
        shadow: Color(0xff000000),
        surface: Color(0xff201a18),
        surfaceTint: Color(0xffffb49d),
        surfaceVariant: Color(0xff53433f),
        tertiary: Color(0xffd8c58d),
        tertiaryContainer: Color(0xff53461a),
        brightness: Brightness.dark,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.purple,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 20),
        bodyMedium: TextStyle(fontSize: 18),
        bodySmall: TextStyle(fontSize: 16),
      ),
      iconTheme: const IconThemeData(color: Colors.purple),
      navigationRailTheme: NavigationRailThemeData(
        selectedLabelTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.purple,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.black.withOpacity(0.8),
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(
            color: Colors.purple,
            width: 2,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.orange,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 20),
        bodyMedium: TextStyle(fontSize: 18),
        bodySmall: TextStyle(fontSize: 16),
      ),
      iconTheme: const IconThemeData(color: Colors.orange),
      navigationRailTheme: NavigationRailThemeData(
        selectedLabelTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.orange,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(Colors.orange),
        trackColor: MaterialStateProperty.all(Colors.orange.withOpacity(0.8)),
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.orange,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
      ),
    );
  }
}
