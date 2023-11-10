import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logger.dart';
import '../../repositories/playlists_repository.dart';

part 'playlist_creation_event.dart';
part 'playlist_creation_state.dart';

class PlaylistCreationBloc
    extends Bloc<PlaylistCreationEvent, PlaylistCreationState> {
  final PlaylistsRepository _playlistsRepository;

  PlaylistCreationBloc(this._playlistsRepository)
      : super(PlaylistCreationInitial()) {
    on<PlaylistCreationLoadingStarted>(_onLoadingCreatePlaylistEvent);
  }

  FutureOr<void> _onLoadingCreatePlaylistEvent(
    PlaylistCreationLoadingStarted event,
    Emitter<PlaylistCreationState> emit,
  ) async {
    emit(PlaylistCreationInProgress());

    try {
      await _playlistsRepository.createPlaylist(event.title);

      emit(PlaylistCreationSuccess());
    } catch (e) {
      emit(PlaylistCreationError());
      logger.e('Error creating playlist: $e');
    }
  }
}
