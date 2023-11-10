part of 'playlist_creation_bloc.dart';

sealed class PlaylistCreationEvent {}

final class PlaylistCreationLoadingStarted extends PlaylistCreationEvent {
  final String title;

  PlaylistCreationLoadingStarted(this.title);
}
