import 'dart:async';

import 'package:basement_music/repositories/tracks_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../utils/log/log_service.dart';

part 'edit_track_event.dart';
part 'edit_track_state.dart';

class EditTrackBloc extends Bloc<EditTrackEvent, EditTrackState> {
  final TracksRepository _tracksRepository;

  EditTrackBloc(this._tracksRepository) : super(GettingInputState()) {
    on<GetInputEvent>(_onGettingInputEvent);
    on<LoadingEvent>(_onLoadingEvent);
  }

  FutureOr<void> _onGettingInputEvent(GetInputEvent event, Emitter<EditTrackState> emit) {
    emit(GettingInputState());
  }

  FutureOr<void> _onLoadingEvent(LoadingEvent event, Emitter<EditTrackState> emit) async {
    emit(WaitingEditingState());

    if (event.title.isEmpty) {
      emit(const InputErrorState('Title must not be empty'));
      return;
    }

    if (event.artist.isEmpty) {
      emit(const InputErrorState('Artist must not be empty'));
      return;
    }

    try {
      final result = await _tracksRepository.editTrack(
        event.trackId,
        event.title,
        event.artist,
        event.cover,
      );

      if (result) {
        emit(EditedState());
      } else {
        emit(EditingErrorState());
      }
    } catch (e) {
      emit(EditingErrorState());
      LogService.log('Error editing track: $e');
    }
  }
}
