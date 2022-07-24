import 'package:flutter/foundation.dart';

var host = kIsWeb ? 'http://localhost:9000' : 'http://10.0.2.2:9000';
const wshost = 'ws://localhost:9000';

var reqAllTracks = '$host/api/tracks';
var trackInfo = '$host/api/track';
var downloadYt = '$host/api/yt/download?url=';
var upload = '$host/api/track/upload';
String trackPlayback(String trackId) => '$trackInfo/$trackId';

var reqAllPlaylists = '$host/api/playlists';
String reqPlaylist(String playlistId) => '$host/api/playlist/$playlistId';
String createPlaylist(String title) => '$host/api/playlist/create/$title';
String addTrackToPlaylist(String playlistId, String trackId) => '$host/api/playlist/$playlistId/addTrack/$trackId';
