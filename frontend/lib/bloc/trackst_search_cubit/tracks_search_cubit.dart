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
    emit(TracksSearchLoadingState());

    try {
      await _tracksRepository.searchTracks(searchQuery);
      if (_tracksRepository.searchItems.isEmpty) {
        emit(TracksSearchEmptyState());
      } else {
        emit(TracksSearchLoadedState(_tracksRepository.searchItems));
      }
    } catch (e) {
      emit(TracksSearchErrorState());
      LogService.log('Error searching tracks: $e');
    }
  }
}
