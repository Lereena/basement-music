import 'dart:async';

import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:basement_music/utils/log/log_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events/tracks_event.dart';
import 'states/tracks_state.dart';

class TracksBloc extends Bloc<TracksEvent, TracksState> {
  final TracksRepository _tracksRepository;

  TracksBloc(this._tracksRepository) : super(TracksLoadingState()) {
    on<TracksLoadEvent>(_onLoadingEvent);
  }

  FutureOr<void> _onLoadingEvent(TracksLoadEvent event, Emitter<TracksState> emit) async {
    emit(TracksLoadingState());

    try {
      final tracksList = await _tracksRepository.getAllTracks();
      if (tracksList.isEmpty)
        emit(TracksEmptyState());
      else
        emit(TracksLoadedState(tracksList));
    } catch (e) {
      emit(TracksErrorState());
      LogService.log('Error loading tracks: $e');
    }
  }
}
