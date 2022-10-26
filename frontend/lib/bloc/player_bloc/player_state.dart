import 'package:basement_music/models/track.dart';

abstract class AudioPlayerState {
  final Track currentTrack;

  AudioPlayerState(this.currentTrack);
}

class InitialPlayerState extends AudioPlayerState {
  InitialPlayerState(super.currentTrack);
}

class PlayingPlayerState extends AudioPlayerState {
  PlayingPlayerState(super.currentTrack);
}

class PausedPlayerState extends AudioPlayerState {
  PausedPlayerState(super.currentTrack);
}

class ResumedPlayerState extends AudioPlayerState {
  ResumedPlayerState(super.currentTrack);
}
