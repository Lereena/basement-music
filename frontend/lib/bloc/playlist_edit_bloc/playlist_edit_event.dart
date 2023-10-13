part of 'playlist_edit_bloc.dart';

@immutable
sealed class PlaylistEditEvent {}

final class PlaylistEditingStartEvent extends PlaylistEditEvent {
  final String playlistId;

  PlaylistEditingStartEvent(this.playlistId);
}

final class PlaylistSaveEvent extends PlaylistEditEvent {
  final String playlistId;
  final String title;
  final List<String> tracksIds;

  PlaylistSaveEvent({
    required this.playlistId,
    required this.title,
    required this.tracksIds,
  });
}
