import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../logger.dart';
import '../../models/track.dart';
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
  ) async {
    final playlist = await _playilstsRepository.getPlaylist(event.playlistId);

    emit(
      PlaylistEditing(
        playlistId: playlist.id,
        title: playlist.title,
        tracks: playlist.tracks,
      ),
    );
  }

  FutureOr<void> _onPlaylistSaveEvent(
    PlaylistSaveEvent event,
    Emitter<PlaylistEditState> emit,
  ) async {
    emit(PlaylistSaving());

    try {
      final result = await _playilstsRepository.editPlaylist(
        id: event.playlistId,
        title: event.title,
        tracksIds: event.tracksIds,
      );

      if (result) {
        await _playilstsRepository.getAllPlaylists();
        emit(PlaylistSavingSuccess());
      } else {
        emit(PlaylistSavingFail());
      }
    } catch (e) {
      emit(PlaylistSavingFail());
      logger.e('Error editing track: $e');
    }
  }
}
