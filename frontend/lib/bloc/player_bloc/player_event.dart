import '../../models/playlist.dart';
import '../../models/track.dart';

abstract class PlayerEvent {}

class PlayEvent extends PlayerEvent {
  final Track track;
  final Playlist? playlist;

  PlayEvent({required this.track, this.playlist});
}

class PauseEvent extends PlayerEvent {}

class ResumeEvent extends PlayerEvent {}

class PreviousEvent extends PlayerEvent {}

class NextEvent extends PlayerEvent {}
