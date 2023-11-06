class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  String get trackInfo => '$baseUrl/api/track';
  String get reqAllPlaylists => '$baseUrl/api/playlists';

  String trackPlayback(String trackId) => '$trackInfo/$trackId';
  String reqPlaylist(String playlistId) => '$baseUrl/api/playlist/$playlistId';
  String reqCreatePlaylist(String title) =>
      '$baseUrl/api/playlist/create/$title';
  String reqTrackPlaylist(String playlistId, String trackId) =>
      '$baseUrl/api/playlist/$playlistId/track/$trackId';
}
