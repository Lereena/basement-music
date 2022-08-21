import 'package:basement_music/models/track.dart';

abstract class AudioPlayerState {
  final Track currentTrack;

  AudioPlayerState(this.currentTrack);
}

class InitialPlayerState extends AudioPlayerState {
  InitialPlayerState(Track currentTrack) : super(currentTrack);
}

class PlayingPlayerState extends AudioPlayerState {
  PlayingPlayerState(Track currentTrack) : super(currentTrack);
}

class PausedPlayerState extends AudioPlayerState {
  PausedPlayerState(Track currentTrack) : super(currentTrack);
}

class ResumedPlayerState extends AudioPlayerState {
  ResumedPlayerState(Track currentTrack) : super(currentTrack);
}
