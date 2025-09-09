part of 'playlist_edit_bloc.dart';

@immutable
sealed class PlaylistEditorEvent {}

final class PlaylistEditorStarted extends PlaylistEditorEvent {}

final class PlaylistEditorSaved extends PlaylistEditorEvent {
  final String title;
  final List<String> tracksIds;

  PlaylistEditorSaved({
    required this.title,
    required this.tracksIds,
  });
}
