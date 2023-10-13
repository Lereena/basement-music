part of 'playlist_edit_bloc.dart';

@immutable
sealed class PlaylistEditState {}

final class PlayilstEditInitial extends PlaylistEditState {}

final class PlayilstEditing extends PlaylistEditState {
  final String playlistId;

  PlayilstEditing(this.playlistId);
}

final class PlayilstSaving extends PlaylistEditState {}

final class PlayilstSavingSuccess extends PlaylistEditState {}

final class PlayilstSavingFail extends PlaylistEditState {}
