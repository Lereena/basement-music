part of 'playilst_edit_bloc.dart';

@immutable
sealed class PlayilstEditEvent {}

final class PlaylistEditingStartEvent extends PlayilstEditEvent {
  final String playlistId;

  PlaylistEditingStartEvent(this.playlistId);
}

final class PlaylistSaveEvent extends PlayilstEditEvent {
  final String playlistId;
  final String title;
  final List<String> tracks;

  PlaylistSaveEvent({
    required this.playlistId,
    required this.title,
    required this.tracks,
  });
}
