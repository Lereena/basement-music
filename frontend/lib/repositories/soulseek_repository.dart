import 'package:basement_music/models/soulseek_connection.dart';
import 'package:basement_music/models/soulseek_search_result.dart';
import 'package:basement_music/models/soulseek_search_results.dart';
import 'package:basement_music/models/soulseek_settings.dart';
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

  /// Starts a search and returns its ticket; results stream in via [searchResults].
  Future<int> startSearch(String query) async {
    final response = await _restClient.startSoulseekSearch(query);
    return response.ticket;
  }

  Future<SoulseekSearchResults> searchResults(int ticket) => _restClient.getSoulseekSearchResults(ticket);

  Future<SoulseekTempTrack> preload(SoulseekSearchResult result) =>
      _restClient.preloadSoulseekTrack(username: result.peerUsername, filename: result.filename);

  Future<Track> save(String tempId, String artist, String title) =>
      _restClient.saveSoulseekTrack(id: tempId, artist: artist, title: title);

  Future<void> cleanup() => _restClient.cleanupSoulseekSession();

  Future<void> disconnect() => _restClient.disconnectSoulseek();

  Future<SoulseekConnection> getConnection() => _restClient.getSoulseekConnection();

  Future<SoulseekSettings> getSettings() => _restClient.getSoulseekSettings();

  Future<void> setDisconnectMinutes(int minutes) => _restClient.setSoulseekSettings(minutes: minutes);
}
