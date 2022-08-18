abstract class TracksState {}

class TracksEmptyState extends TracksState {}

class TracksLoadingState extends TracksState {}

class TracksLoadedState extends TracksState {
  final List<dynamic> tracks;

  TracksLoadedState(this.tracks);
}

class TracksErrorState extends TracksState {}
