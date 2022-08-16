import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/playlists_repository.dart';
import '../utils/log/log_service.dart';
import 'events/create_playlist_event.dart';
import 'states/create_playlist_state.dart';

class CreatePlaylistBloc extends Bloc<CreatePlaylistEvent, CreatePlaylistState> {
  final PlaylistsRepository _playlistsRepository;

  CreatePlaylistBloc(this._playlistsRepository) : super(GettingInputState()) {
    on<GetInputEvent>(_onGettingInputEvent);
    on<LoadingCreatePlaylistEvent>(_onLoadingCreatePlaylistEvent);
  }

  FutureOr<void> _onGettingInputEvent(GetInputEvent event, Emitter<CreatePlaylistState> emit) async {
    emit(GettingInputState());
  }

  FutureOr<void> _onLoadingCreatePlaylistEvent(
      LoadingCreatePlaylistEvent event, Emitter<CreatePlaylistState> emit) async {
    emit(CreatingPlaylistState());

    try {
      final result = await _playlistsRepository.createPlaylist(event.title);

      if (result)
        emit(PlaylistCreatedState());
      else
        emit(CreatePlaylistErrorState());
    } catch (e) {
      emit(CreatePlaylistErrorState());
      LogService.log('Error creating playlist: $e');
    }
  }
}
