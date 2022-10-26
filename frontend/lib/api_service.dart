import 'package:flutter/foundation.dart';

class ApiService {
  late String _host;

  ApiService([String? host]) {
    if (host != null && host.isNotEmpty) {
      _host = host;
    } else {
      _host = kIsWeb ? '' : 'http://10.0.2.2:9000';
    }
  }

  void setHost(String value) {
    if (value.isNotEmpty) {
      _host = value;
    }
  }

  String get reqAllTracks => '$_host/api/tracks';
  String get trackInfo => '$_host/api/track';
  String get upload => '$_host/api/track/upload';
  String get reqAllPlaylists => '$_host/api/playlists';

  String trackPlayback(String trackId) => '$trackInfo/$trackId';
  String reqPlaylist(String playlistId) => '$_host/api/playlist/$playlistId';
  String reqCreatePlaylist(String title) => '$_host/api/playlist/create/$title';
  String reqAddTrackToPlaylist(String playlistId, String trackId) => '$_host/api/playlist/$playlistId/track/$trackId';
  String reqYtDownload(String link, String artist, String title) =>
      '$_host/api/yt/download?url=$link&artist=$artist&title=$title';
}
