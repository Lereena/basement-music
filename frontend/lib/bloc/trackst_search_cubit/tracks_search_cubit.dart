import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../repositories/tracks_repository.dart';
import '../../utils/log/log_service.dart';
import '../playlists_bloc/playlists_bloc.dart';

part 'tracks_search_state.dart';

class TracksSearchCubit extends Cubit<TracksSearchState> {
  final TracksRepository _tracksRepository;
  final PlaylistsBloc _playlistsBloc;

  TracksSearchCubit(this._tracksRepository, this._playlistsBloc) : super(TracksSearchInitial());

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
      await _tracksRepository.searchTracks(query);
      if (_tracksRepository.searchItems.isEmpty) {
        emit(TracksSearchEmptyState(query));
      } else {
        searchResultsPlaylist = Playlist.anonymous(_tracksRepository.searchItems);
        _playlistsBloc.openedPlaylist = searchResultsPlaylist;

        emit(TracksSearchLoadedState(query, _tracksRepository.searchItems));
      }
    } catch (e) {
      emit(TracksSearchErrorState());
      LogService.log('Error searching tracks: $e');
    }
  }
}
