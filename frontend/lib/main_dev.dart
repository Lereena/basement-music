import 'dart:io';

import 'app_config.dart';
import 'main.dart';

void main() async {
  final config = AppConfig(
    baseUrl:
        Platform.isAndroid ? 'http://10.0.2.2:9000' : 'http://localhost:9000',
  );

  runBasement(config);
}
