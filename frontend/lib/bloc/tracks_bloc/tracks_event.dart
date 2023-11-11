part of 'tracks_bloc.dart';

@immutable
sealed class TracksEvent {}

final class TracksLoadStarted extends TracksEvent {}

final class TracksUpdated extends TracksEvent {
  final List<Track> tracks;

  TracksUpdated(this.tracks);
}
