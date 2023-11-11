part of 'tracks_bloc.dart';

sealed class TracksEvent {}

final class TracksLoadStarted extends TracksEvent {}

final class TracksUpdated extends TracksEvent {
  List<Track> tracks;

  TracksUpdated(this.tracks);
}
