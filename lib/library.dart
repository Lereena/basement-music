import 'models/playlist.dart';
import 'models/track.dart';

List<Track> tracks = [];

Set<String> cachedTracks = {};

List<Playlist> playlists = [];

Playlist openedPlaylist = Playlist.all();
