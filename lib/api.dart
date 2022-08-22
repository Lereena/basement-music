import 'package:flutter/foundation.dart';

String host = kIsWeb ? 'http://localhost:9000' : 'http://10.0.2.2:9000';
const wshost = 'ws://localhost:9000';

String reqAllTracks = '$host/api/tracks';
String trackInfo = '$host/api/track';
String downloadYt = '$host/api/yt/download';
String upload = '$host/api/track/upload';
String trackPlayback(String trackId) => '$trackInfo/$trackId';

String reqAllPlaylists = '$host/api/playlists';
String reqPlaylist(String playlistId) => '$host/api/playlist/$playlistId';
String reqCreatePlaylist(String title) => '$host/api/playlist/create/$title';
String reqAddTrackToPlaylist(String playlistId, String trackId) => '$host/api/playlist/$playlistId/track/$trackId';
String reqYtDownload(String link, String artist, String title) => '$downloadYt?url=$link&artist=$artist&title=$title';
