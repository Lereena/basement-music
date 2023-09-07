import 'app.dart';
import 'app_config.dart';

void main() async {
  const config = AppConfig(baseUrl: 'https://basement.madetara.dev');

  runBasement(config);
}
