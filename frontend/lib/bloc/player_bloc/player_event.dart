import 'package:basement_music/models/track.dart';

abstract class PlayerEvent {}

class PlayEvent extends PlayerEvent {
  final Track track;

  PlayEvent(this.track);
}

class PauseEvent extends PlayerEvent {}

class ResumeEvent extends PlayerEvent {}

class PreviousEvent extends PlayerEvent {}

class NextEvent extends PlayerEvent {}
