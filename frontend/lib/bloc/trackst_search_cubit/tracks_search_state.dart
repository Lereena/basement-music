part of 'tracks_search_cubit.dart';

@immutable
sealed class TracksSearchState {
  final String searchQuery;

  const TracksSearchState(this.searchQuery);
}

final class TracksSearchInitial extends TracksSearchState {
  const TracksSearchInitial() : super('');
}

final class TracksSearchLoadInProgress extends TracksSearchState {
  const TracksSearchLoadInProgress(super.searchQuery);
}

final class TracksSearchSuccess extends TracksSearchState {
  final List<Track> tracks;

  const TracksSearchSuccess(super.searchQuery, this.tracks);
}

final class TracksSearchSuccessEmpty extends TracksSearchState {
  const TracksSearchSuccessEmpty(super.searchQuery);
}

final class TracksSearchError extends TracksSearchState {
  const TracksSearchError() : super('');
}
