class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  String get reqAllTracks => '$baseUrl/api/tracks';
  String get trackInfo => '$baseUrl/api/track';
  String get upload => '$baseUrl/api/track/upload';
  String get reqAllPlaylists => '$baseUrl/api/playlists';

  String trackPlayback(String trackId) => '$trackInfo/$trackId';
  String reqPlaylist(String playlistId) => '$baseUrl/api/playlist/$playlistId';
  String reqCreatePlaylist(String title) =>
      '$baseUrl/api/playlist/create/$title';
  String reqEditPlayilst(String playlistId) =>
      '$baseUrl/api/playilst/edit/$playlistId';
  String reqTrackPlaylist(String playlistId, String trackId) =>
      '$baseUrl/api/playlist/$playlistId/track/$trackId';
  String reqYtVideoInfo(String link) =>
      '$baseUrl/api/yt/fetchVideoInfo?url=$link';
  String reqYtDownload(String link, String artist, String title) =>
      '$baseUrl/api/yt/download?url=$link&artist=$artist&title=$title';

  String reqSearch(String searchQuery) =>
      '$reqAllTracks/search?query=$searchQuery';
}
