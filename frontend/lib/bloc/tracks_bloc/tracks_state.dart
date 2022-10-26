import '../../models/track.dart';

abstract class TracksState {}

class TracksEmptyState extends TracksState {}

class TracksLoadingState extends TracksState {}

class TracksLoadedState extends TracksState {
  final List<Track> tracks;

  TracksLoadedState(this.tracks);
}

class TracksErrorState extends TracksState {}
