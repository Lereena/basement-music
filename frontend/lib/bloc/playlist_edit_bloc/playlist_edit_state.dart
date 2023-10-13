part of 'playlist_edit_bloc.dart';

@immutable
sealed class PlaylistEditState {}

final class PlayilstEditInitial extends PlaylistEditState {}

final class PlaylistEditing extends PlaylistEditState {
  final String playlistId;
  final String title;
  final List<Track> tracks;

  PlaylistEditing({
    required this.playlistId,
    required this.title,
    required this.tracks,
  });
}

final class PlaylistSaving extends PlaylistEditState {}

final class PlaylistSavingSuccess extends PlaylistEditState {}

final class PlaylistSavingFail extends PlaylistEditState {}
