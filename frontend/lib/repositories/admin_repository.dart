import 'package:basement_music/models/registration_code.dart';
import 'package:basement_music/rest_client.dart';

class AdminRepository {
  AdminRepository(this._restClient);

  final RestClient _restClient;

  Future<RegistrationCode> generateCode() => _restClient.generateRegistrationCode();

  Future<List<RegistrationCode>> getCodes() => _restClient.getRegistrationCodes();
}
