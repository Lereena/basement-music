import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../logger.dart';
import '../../repositories/playlists_repository.dart';

part 'playlist_edit_event.dart';
part 'playlist_edit_state.dart';

class PlaylistEditBloc extends Bloc<PlaylistEditEvent, PlaylistEditState> {
  final PlaylistsRepository _playilstsRepository;

  PlaylistEditBloc(this._playilstsRepository) : super(PlayilstEditInitial()) {
    on<PlaylistEditingStartEvent>(_onPlaylistEditEvent);
    on<PlaylistSaveEvent>(_onPlaylistSaveEvent);
  }

  FutureOr<void> _onPlaylistEditEvent(
    PlaylistEditingStartEvent event,
    Emitter<PlaylistEditState> emit,
  ) {
    emit(PlayilstEditing(event.playlistId));
  }

  FutureOr<void> _onPlaylistSaveEvent(
    PlaylistSaveEvent event,
    Emitter<PlaylistEditState> emit,
  ) async {
    emit(PlayilstSaving());

    try {
      final result = await _playilstsRepository.editPlaylist(
        id: event.playlistId,
        title: event.title,
        tracksIds: event.tracks,
      );

      if (result) {
        await _playilstsRepository.getAllPlaylists();
        emit(PlayilstSavingSuccess());
      } else {
        emit(PlayilstSavingFail());
      }
    } catch (e) {
      emit(PlayilstSavingFail());
      logger.e('Error editing track: $e');
    }
  }
}
