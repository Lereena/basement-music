@JS()
library js_calls;

import 'package:js/js.dart';

@JS('window.setLogDebug')
external set signUpForLogStatusJS(void Function(bool res) f);
