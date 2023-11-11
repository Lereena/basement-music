part of 'playlist_edit_bloc.dart';

@immutable
sealed class PlaylistEditState {}

final class PlayilstEditInitial extends PlaylistEditState {}

final class PlaylistEditorEditInProgress extends PlaylistEditState {
  final String playlistId;
  final String title;
  final List<Track> tracks;

  PlaylistEditorEditInProgress({
    required this.playlistId,
    required this.title,
    required this.tracks,
  });
}

final class PlaylistEditorSaveInProgress extends PlaylistEditState {}

final class PlaylistEditorSuccess extends PlaylistEditState {}

final class PlaylistEditorFail extends PlaylistEditState {}
