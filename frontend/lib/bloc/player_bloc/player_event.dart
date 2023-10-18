import '../../models/playlist.dart';

abstract class PlayerEvent {}

class SetTrackEvent extends PlayerEvent {
  final String trackId;

  SetTrackEvent({required this.trackId});
}

class PlayEvent extends PlayerEvent {
  final String trackId;
  final Playlist? playlist;

  PlayEvent({required this.trackId, this.playlist});
}

class PauseEvent extends PlayerEvent {}

class ResumeEvent extends PlayerEvent {}

class PreviousEvent extends PlayerEvent {}

class NextEvent extends PlayerEvent {}
