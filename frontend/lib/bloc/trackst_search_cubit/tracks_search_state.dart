part of 'tracks_search_cubit.dart';

abstract class TracksSearchState {
  final String searchQuery;

  TracksSearchState(this.searchQuery);
}

class TracksSearchInitial extends TracksSearchState {
  TracksSearchInitial() : super('');
}

class TracksSearchEmptyState extends TracksSearchState {
  TracksSearchEmptyState(super.searchQuery);
}

class TracksSearchLoadingState extends TracksSearchState {
  TracksSearchLoadingState(super.searchQuery);
}

class TracksSearchLoadedState extends TracksSearchState {
  final List<Track> tracks;

  TracksSearchLoadedState(super.searchQuery, this.tracks);
}

class TracksSearchErrorState extends TracksSearchState {
  TracksSearchErrorState() : super('');
}
