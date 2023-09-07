import 'app_config.dart';
import 'main.dart';

void main() async {
  const config = AppConfig(baseUrl: 'https://basement.madetara.dev');

  runBasement(config);
}
