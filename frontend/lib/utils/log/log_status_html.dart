// ignore: avoid_web_libraries_in_flutter
import 'dart:js';

import 'log_status_js.dart';

void signUp(void Function(bool res) f) {
  signUpForLogStatusJS = allowInterop(f);
}
