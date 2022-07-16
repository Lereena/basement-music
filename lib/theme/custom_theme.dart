import 'package:flutter/material.dart';

import '../settings.dart';

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  ThemeMode get currentThemeMode => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void initTheme() async {
    _isDarkTheme = await getDarkTheme();
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.purple,
      textTheme: TextTheme(
        bodyLarge: const TextStyle(fontSize: 20),
        bodyMedium: const TextStyle(fontSize: 18),
        bodySmall: const TextStyle(fontSize: 16),
      ),
      navigationRailTheme: NavigationRailThemeData(
        selectedLabelTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.purple,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.black.withOpacity(0.8),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.orange,
      textTheme: TextTheme(
        bodyLarge: const TextStyle(fontSize: 20),
        bodyMedium: const TextStyle(fontSize: 18),
        bodySmall: const TextStyle(fontSize: 16),
      ),
      iconTheme: IconThemeData(color: Colors.orange),
      navigationRailTheme: NavigationRailThemeData(
        selectedLabelTextStyle: TextStyle(
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
      appBarTheme: AppBarTheme(
        color: Colors.orange,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }
}
