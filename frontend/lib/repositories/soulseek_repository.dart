import 'package:basement_music/models/soulseek_search_result.dart';
import 'package:basement_music/models/soulseek_status.dart';
import 'package:basement_music/models/soulseek_temp_track.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/rest_client.dart';

class SoulseekRepository {
  SoulseekRepository(this._restClient);

  final RestClient _restClient;

  Future<void> setCredentials(String username, String password) =>
      _restClient.setSoulseekCredentials(username: username, password: password);

  Future<SoulseekStatus> getStatus() => _restClient.getSoulseekStatus();

  Future<List<SoulseekSearchResult>> search(String query) => _restClient.searchSoulseek(query);

  Future<SoulseekTempTrack> preload(SoulseekSearchResult result) =>
      _restClient.preloadSoulseekTrack(username: result.peerUsername, filename: result.filename);

  Future<Track> save(String tempId) => _restClient.saveSoulseekTrack(id: tempId);

  Future<void> cleanup() => _restClient.cleanupSoulseekSession();

  Future<void> disconnect() => _restClient.disconnectSoulseek();
}
