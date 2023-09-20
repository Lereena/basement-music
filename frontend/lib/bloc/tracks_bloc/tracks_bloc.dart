import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logger.dart';
import '../../repositories/tracks_repository.dart';
import 'tracks_event.dart';
import 'tracks_state.dart';

class TracksBloc extends Bloc<TracksEvent, TracksState> {
  final TracksRepository _tracksRepository;

  TracksBloc(this._tracksRepository) : super(TracksLoadingState()) {
    on<TracksLoadEvent>(_onLoadingEvent);
  }

  FutureOr<void> _onLoadingEvent(
    TracksLoadEvent event,
    Emitter<TracksState> emit,
  ) async {
    emit(TracksLoadingState());

    try {
      await _tracksRepository.getAllTracks();
      if (_tracksRepository.items.isEmpty) {
        emit(TracksEmptyState());
      } else {
        emit(TracksLoadedState(_tracksRepository.items));
      }
    } catch (e) {
      emit(TracksErrorState());
      logger.e('Error loading tracks: $e');
    }
  }
}
