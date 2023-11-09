import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logger.dart';
import '../../repositories/playlists_repository.dart';
import 'playlist_creation_event.dart';
import 'playlist_creation_state.dart';

class PlaylistCreationBloc
    extends Bloc<PlaylistCreationEvent, PlaylistCreationState> {
  final PlaylistsRepository _playlistsRepository;

  PlaylistCreationBloc(this._playlistsRepository) : super(GettingInputState()) {
    on<GetInputEvent>(_onGettingInputEvent);
    on<LoadingEvent>(_onLoadingCreatePlaylistEvent);
  }

  FutureOr<void> _onGettingInputEvent(
    GetInputEvent event,
    Emitter<PlaylistCreationState> emit,
  ) async {
    emit(GettingInputState());
  }

  FutureOr<void> _onLoadingCreatePlaylistEvent(
    LoadingEvent event,
    Emitter<PlaylistCreationState> emit,
  ) async {
    emit(WaitingCreationState());

    try {
      await _playlistsRepository.createPlaylist(event.title);

      emit(CreatedState());
    } catch (e) {
      emit(CreationErrorState());
      logger.e('Error creating playlist: $e');
    }
  }
}
