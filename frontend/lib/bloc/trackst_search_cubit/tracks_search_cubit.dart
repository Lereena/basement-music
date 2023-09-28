import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../logger.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../repositories/tracks_repository.dart';
import '../cacher_bloc/cacher_bloc.dart';
import '../connectivity_status_bloc/connectivity_status_cubit.dart';
import '../playlists_bloc/playlists_bloc.dart';

part 'tracks_search_state.dart';

class TracksSearchCubit extends Cubit<TracksSearchState> {
  final TracksRepository tracksRepository;
  final PlaylistsBloc playlistsBloc;
  final CacherBloc cacherBloc;
  final ConnectivityStatusCubit connectivityStatusCubit;

  TracksSearchCubit({
    required this.tracksRepository,
    required this.playlistsBloc,
    required this.cacherBloc,
    required this.connectivityStatusCubit,
  }) : super(TracksSearchInitial());

  Playlist searchResultsPlaylist = Playlist.empty();

  String lastSearch = '';

  FutureOr<void> onSearch(String searchQuery) async {
    final query = searchQuery.trim();
    if (lastSearch == query) return;
    lastSearch = query;

    if (query.isEmpty) {
      emit(TracksSearchInitial());
      return;
    }

    emit(TracksSearchLoadingState(query));

    try {
      if (connectivityStatusCubit.state is NoConnectionState) {
        tracksRepository.searchTracksOffline(query);
      } else {
        await tracksRepository.searchTracksOnline(query);
      }

      if (tracksRepository.searchItems.isEmpty) {
        emit(TracksSearchEmptyState(query));
      } else {
        searchResultsPlaylist =
            Playlist.anonymous(tracksRepository.searchItems);
        playlistsBloc.openedPlaylist = searchResultsPlaylist;

        emit(TracksSearchLoadedState(query, tracksRepository.searchItems));
      }
    } catch (e) {
      emit(TracksSearchErrorState());
      logger.e('Error searching tracks: $e');
    }
  }
}
