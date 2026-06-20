import 'package:basement_music/app.dart';
import 'package:basement_music/app_config.dart';
import 'package:flutter/foundation.dart';

const _devHost = String.fromEnvironment('DEV_HOST', defaultValue: '10.0.2.2');
const _mobileBackend = 'http://$_devHost:9000';
const _localhost = 'http://localhost:9000';

void main() {
  String baseUrl = _localhost;

  if (!kIsWeb) {
    baseUrl = _mobileBackend;
  }

  final config = AppConfig(baseUrl: baseUrl);

  runBasement(config);
}
