import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../models/track.dart';
import '../../repositories/tracks_repository.dart';
import '../../utils/log/log_service.dart';

part 'tracks_search_state.dart';

class TracksSearchCubit extends Cubit<TracksSearchState> {
  final TracksRepository _tracksRepository;

  TracksSearchCubit(this._tracksRepository) : super(TracksSearchInitial());

  FutureOr<void> onSearch(String searchQuery) async {
    if (searchQuery.trim().isEmpty) {
      emit(TracksSearchInitial());
      return;
    }

    emit(TracksSearchLoadingState(searchQuery));

    try {
      await _tracksRepository.searchTracks(searchQuery);
      if (_tracksRepository.searchItems.isEmpty) {
        emit(TracksSearchEmptyState(searchQuery));
      } else {
        emit(TracksSearchLoadedState(searchQuery, _tracksRepository.searchItems));
      }
    } catch (e) {
      emit(TracksSearchErrorState());
      LogService.log('Error searching tracks: $e');
    }
  }
}
