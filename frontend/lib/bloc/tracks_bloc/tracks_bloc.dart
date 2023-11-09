import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../logger.dart';
import '../../repositories/connectivity_status_repository.dart';
import '../../repositories/tracks_repository.dart';
import '../connectivity_status_bloc/connectivity_status_cubit.dart';
import 'tracks_event.dart';
import 'tracks_state.dart';

const _tracksInfoKey = 'tracksInfo';

class TracksBloc extends HydratedBloc<TracksEvent, TracksState> {
  final TracksRepository tracksRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;

  TracksBloc({
    required this.tracksRepository,
    required this.connectivityStatusRepository,
  }) : super(TracksLoadingState()) {
    on<TracksLoadEvent>(_onLoadingEvent);

    connectivityStatusRepository.statusSubject.listen((status) {
      if (status is ConnectivityStatusHasConnection) add(TracksLoadEvent());
    });
  }

  FutureOr<void> _onLoadingEvent(
    TracksLoadEvent event,
    Emitter<TracksState> emit,
  ) async {
    final oldState = state;
    emit(TracksLoadingState());

    try {
      await tracksRepository.getAllTracks();

      if (tracksRepository.items.isEmpty) {
        emit(TracksEmptyState());
      } else {
        emit(TracksLoadedState(tracksRepository.items));
      }
    } catch (e) {
      if (oldState.tracks.isNotEmpty) {
        emit(TracksLoadedState(oldState.tracks));
      } else {
        emit(TracksErrorState());
      }
      logger.e('Error loading tracks: $e');
    }
  }

  @override
  TracksState? fromJson(Map<String, dynamic> json) {
    final state = TracksState.fromJson(json[_tracksInfoKey] as String);
    if (state.tracks.isNotEmpty) {
      return TracksLoadedState(state.tracks);
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(TracksState state) =>
      {_tracksInfoKey: state.toJson()};
}
