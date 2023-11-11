import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../logger.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../repositories/repositories.dart';

part 'tracks_search_state.dart';

class TracksSearchCubit extends Cubit<TracksSearchState> {
  final TracksRepository tracksRepository;
  final PlaylistsRepository playlistsRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;

  TracksSearchCubit({
    required this.tracksRepository,
    required this.playlistsRepository,
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

    emit(TracksSearchLoadInProgress(query));

    try {
      if (connectivityStatusRepository.statusSubject.value ==
          ConnectivityResult.none) {
        tracksRepository.searchTracksOffline(query);
      } else {
        await tracksRepository.searchTracksOnline(query);
      }

      if (tracksRepository.searchItems.isEmpty) {
        emit(TracksSearchSuccessEmpty(query));
      } else {
        playlistsRepository.openedPlaylist =
            Playlist.anonymous(tracksRepository.searchItems);

        emit(TracksSearchSuccess(query, tracksRepository.searchItems));
      }
    } catch (e) {
      emit(TracksSearchError());
      logger.e('Error searching tracks: $e');
    }
  }
}
