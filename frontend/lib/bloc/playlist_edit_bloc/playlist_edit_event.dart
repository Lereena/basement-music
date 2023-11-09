part of 'playlist_edit_bloc.dart';

@immutable
sealed class PlaylistEditEvent {}

final class PlaylistEditingStartEvent extends PlaylistEditEvent {}

final class PlaylistSaveEvent extends PlaylistEditEvent {
  final String title;
  final List<String> tracksIds;

  PlaylistSaveEvent({
    required this.title,
    required this.tracksIds,
  });
}
