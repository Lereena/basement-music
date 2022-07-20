import 'package:flutter/foundation.dart';

const host = kIsWeb ? 'http://localhost:9000' : 'http://10.0.2.2:9000';
const wshost = 'ws://localhost:9000';

const reqAllTracks = '$host/tracks';
const trackInfo = '$host/track';
const downloadYt = '$host/yt/download?url=';
const upload = '$host/track/upload';
String trackPlayback(String trackId) => '$trackInfo/$trackId';

const reqAllPlaylists = '$host/playlists';
String reqPlaylist(String playlistId) => '$host/playlist/$playlistId';
String createPlaylist(String title) => '$host/playlist/create/$title';
String addTrackToPlaylist(String playlistId, String trackId) => '$host/playlist/$playlistId/addTrack/$trackId';
