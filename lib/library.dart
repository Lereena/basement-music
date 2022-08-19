import 'models/playlist.dart';
import 'models/track.dart';

List<Track> tracks = []; // TODO: remove

Set<String> cachedTracks = {};

List<Playlist> playlists = [];

Playlist openedPlaylist = Playlist.empty();
