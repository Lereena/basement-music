import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../logger.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../repositories/connectivity_status_repository.dart';
import '../../repositories/playlists_repository.dart';
import '../../repositories/tracks_repository.dart';
import '../cacher_bloc/cacher_bloc.dart';

part 'tracks_search_state.dart';

class TracksSearchCubit extends Cubit<TracksSearchState> {
  final TracksRepository tracksRepository;
  final PlaylistsRepository playlistsRepository;
  final CacherBloc cacherBloc;
  final ConnectivityStatusRepository connectivityStatusRepository;

  TracksSearchCubit({
    required this.tracksRepository,
    required this.playlistsRepository,
    required this.cacherBloc,
    required this.connectivityStatusRepository,
  }) : super(TracksSearchInitial());

  Playlist get openedPlaylist => playlistsRepository.openedPlaylist;

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
      if (connectivityStatusRepository.statusSubject.value ==
          ConnectivityResult.none) {
        tracksRepository.searchTracksOffline(query);
      } else {
        await tracksRepository.searchTracksOnline(query);
      }

      if (tracksRepository.searchItems.isEmpty) {
        emit(TracksSearchEmptyState(query));
      } else {
        playlistsRepository.openedPlaylist =
            Playlist.anonymous(tracksRepository.searchItems);

        emit(TracksSearchLoadedState(query, tracksRepository.searchItems));
      }
    } catch (e) {
      emit(TracksSearchErrorState());
      logger.e('Error searching tracks: $e');
    }
  }
}
