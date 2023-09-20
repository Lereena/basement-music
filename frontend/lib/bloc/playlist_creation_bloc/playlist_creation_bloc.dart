import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logger.dart';
import '../../repositories/playlists_repository.dart';
import '../playlists_bloc/playlists_bloc.dart';
import '../playlists_bloc/playlists_event.dart';
import 'playlist_creation_event.dart';
import 'playlist_creation_state.dart';

class PlaylistCreationBloc
    extends Bloc<PlaylistCreationEvent, PlaylistCreationState> {
  final PlaylistsRepository _playlistsRepository;
  final PlaylistsBloc _playlistsBloc;

  PlaylistCreationBloc(this._playlistsRepository, this._playlistsBloc)
      : super(GettingInputState()) {
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

    if (event.title.isEmpty) {
      emit(const InputErrorState('Title must not be empty'));
      return;
    }

    try {
      final result = await _playlistsRepository.createPlaylist(event.title);

      if (result) {
        emit(CreatedState());
        _playlistsBloc.add(PlaylistAddedEvent());
      } else {
        emit(CreationErrorState());
      }
    } catch (e) {
      emit(CreationErrorState());
      logger.e('Error creating playlist: $e');
    }
  }
}
