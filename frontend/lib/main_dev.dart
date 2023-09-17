import 'dart:io';

import 'package:flutter/foundation.dart';

import 'app.dart';
import 'app_config.dart';

const _androidLocalhost = 'http://10.0.2.2:9000';
const _localhost = 'http://localhost:9000';

void main() async {
  String baseUrl = _localhost;
  if (!kIsWeb && Platform.isAndroid) {
    baseUrl = _androidLocalhost;
  }

  final config = AppConfig(baseUrl: baseUrl);

  runBasement(config);
}
