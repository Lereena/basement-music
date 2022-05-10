import 'package:basement_music/models/track.dart';

abstract class AudioPlayerState {
  final Track currentTrack;

  AudioPlayerState(this.currentTrack);
}

class InitialPlayerState extends AudioPlayerState {
  final Track currentTrack;

  InitialPlayerState(this.currentTrack) : super(currentTrack);
}

class PlayingPlayerState extends AudioPlayerState {
  final Track currentTrack;

  PlayingPlayerState(this.currentTrack) : super(currentTrack);
}

class PausedPlayerState extends AudioPlayerState {
  final Track currentTrack;

  PausedPlayerState(this.currentTrack) : super(currentTrack);
}

class ResumedPlayerState extends AudioPlayerState {
  final Track currentTrack;

  ResumedPlayerState(this.currentTrack) : super(currentTrack);
}
