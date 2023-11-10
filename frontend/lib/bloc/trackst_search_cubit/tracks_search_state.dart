part of 'tracks_search_cubit.dart';

sealed class TracksSearchState {
  final String searchQuery;

  TracksSearchState(this.searchQuery);
}

final class TracksSearchInitial extends TracksSearchState {
  TracksSearchInitial() : super('');
}

final class TracksSearchLoadInProgress extends TracksSearchState {
  TracksSearchLoadInProgress(super.searchQuery);
}

final class TracksSearchSuccess extends TracksSearchState {
  final List<Track> tracks;

  TracksSearchSuccess(super.searchQuery, this.tracks);
}

final class TracksSearchSuccessEmpty extends TracksSearchState {
  TracksSearchSuccessEmpty(super.searchQuery);
}

final class TracksSearchError extends TracksSearchState {
  TracksSearchError() : super('');
}
