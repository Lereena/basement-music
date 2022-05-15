import 'package:shared_preferences/shared_preferences.dart';

Future<void> setShuffle(bool value) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setBool('shuffle', value);
}

Future<bool> getShuffle() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getBool('shuffle') ?? false;
}

Future<void> setRepeat(bool value) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setBool('repeat', value);
}

Future<bool> getRepeat() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getBool('repeat') ?? false;
}
