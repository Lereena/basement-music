part of 'playlist_creation_bloc.dart';

@immutable
sealed class PlaylistCreationState {}

final class PlaylistCreationInitial extends PlaylistCreationState {}

final class PlaylistCreationInProgress extends PlaylistCreationState {}

final class PlaylistCreationSuccess extends PlaylistCreationState {}

final class PlaylistCreationError extends PlaylistCreationState {}
