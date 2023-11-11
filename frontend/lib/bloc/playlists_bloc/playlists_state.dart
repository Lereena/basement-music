part of 'playlists_bloc.dart';

@immutable
class PlaylistsState {
  final List<Playlist> playlists;

  const PlaylistsState(this.playlists);

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

final class PlaylistsEmptyState extends PlaylistsState {
  PlaylistsEmptyState() : super([]);
}

final class PlaylistsLoadingState extends PlaylistsState {
  PlaylistsLoadingState() : super([]);
}

final class PlaylistsLoadedState extends PlaylistsState {
  const PlaylistsLoadedState(super.playlists);
}

final class PlaylistsErrorState extends PlaylistsState {
  PlaylistsErrorState() : super([]);
}
