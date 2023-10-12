import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../logger.dart';
import '../../models/playlist.dart';
import '../../repositories/playlists_repository.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final PlaylistsRepository _playlistsRepository;

  PlaylistBloc(this._playlistsRepository) : super(PlaylistInitial()) {
    on<PlaylistLoadEvent>(_onLoadingEvent);
  }

  FutureOr<void> _onLoadingEvent(
    PlaylistLoadEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    emit(PlaylistLoadingState());

    try {
      final playlist = await _playlistsRepository.getPlaylist(event.playlistId);

      if (playlist.tracks.isEmpty) {
        emit(PlaylistEmptyState(title: playlist.title));
      } else {
        emit(PlaylistLoadedState(playlist));
      }
    } catch (e) {
      emit(PlaylistErrorState());
      logger.e('Error loading playlist: $e');
    }
  }
}
