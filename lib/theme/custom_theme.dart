import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.purple,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 20),
        bodyMedium: TextStyle(fontSize: 18),
        bodySmall: TextStyle(fontSize: 16),
      ),
      iconTheme: IconThemeData(color: Colors.black.withOpacity(0.6)),
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
