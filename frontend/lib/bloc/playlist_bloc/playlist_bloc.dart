import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../logger.dart';
import '../../models/playlist.dart';
import '../../repositories/playlists_repository.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final PlaylistsRepository playlistsRepository;
  final String playlistId;

  PlaylistBloc({required this.playlistsRepository, required this.playlistId})
      : super(PlaylistInitial()) {
    on<PlaylistLoadStarted>(_onLoadingEvent);
    on<PlaylistUpdated>(_onPlaylistUpdated);

    playlistsRepository.playlistsSubject.listen(
      (value) => add(
        PlaylistUpdated(
          value.firstWhere((element) => element.id == playlistId),
        ),
      ),
    );
  }

  FutureOr<void> _onLoadingEvent(
    PlaylistLoadStarted event,
    Emitter<PlaylistState> emit,
  ) async {
    emit(PlaylistLoadInProgress());

    try {
      final playlist = await playlistsRepository.getPlaylist(playlistId);

      if (playlist.tracks.isEmpty) {
        emit(PlaylistLoadedEmpty(title: playlist.title));
      } else {
        emit(PlaylistLoaded(playlist));
      }
    } catch (e) {
      emit(PlaylistError());
      logger.e('Error loading playlist: $e');
    }
  }

  FutureOr<void> _onPlaylistUpdated(
    PlaylistUpdated event,
    Emitter<PlaylistState> emit,
  ) {
    emit(PlaylistLoaded(event.playlist));
  }
}
