part of 'tracks_search_cubit.dart';

abstract class TracksSearchState {}

class TracksSearchInitial extends TracksSearchState {}

class TracksSearchEmptyState extends TracksSearchState {}

class TracksSearchLoadingState extends TracksSearchState {}

class TracksSearchLoadedState extends TracksSearchState {
  final List<Track> tracks;

  TracksSearchLoadedState(this.tracks);
}

class TracksSearchErrorState extends TracksSearchState {}
