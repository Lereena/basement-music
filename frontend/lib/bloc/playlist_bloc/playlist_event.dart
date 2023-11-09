part of 'playlist_bloc.dart';

@immutable
sealed class PlaylistEvent {}

class PlaylistLoadEvent extends PlaylistEvent {}

class PlaylistsUpdatedEvent extends PlaylistEvent {}
