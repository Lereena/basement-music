import 'package:basement_music/app.dart';
import 'package:basement_music/app_config.dart';

void main() {
  const config = AppConfig(baseUrl: 'https://basement.madetara.dev');

  runBasement(config);
}
