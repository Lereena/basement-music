import 'dart:convert';

import '../../models/playlist.dart';

class PlaylistsState {
  final List<Playlist> playlists;

  PlaylistsState(this.playlists);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'playlists': json.encode(playlists.map((e) => e.toJson()).toList()),
    };
  }

  factory PlaylistsState.fromMap(Map<String, dynamic> map) {
    return PlaylistsState(
      (json.decode(map['playlists'] as String) as List<dynamic>)
          .map<Playlist>(
            (e) => Playlist.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaylistsState.fromJson(String source) =>
      PlaylistsState.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PlaylistsEmptyState extends PlaylistsState {
  PlaylistsEmptyState() : super([]);
}

class PlaylistsLoadingState extends PlaylistsState {
  PlaylistsLoadingState() : super([]);
}

class PlaylistsLoadedState extends PlaylistsState {
  PlaylistsLoadedState(super.playlists);
}

class PlaylistsErrorState extends PlaylistsState {
  PlaylistsErrorState() : super([]);
}
