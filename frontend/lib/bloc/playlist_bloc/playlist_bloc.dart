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
    on<PlaylistLoadEvent>(_onLoadingEvent);

    playlistsRepository.playlistsSubject.listen(
      (value) => PlaylistLoadedState(
        value.firstWhere((element) => element.id == playlistId),
      ),
    );
  }

  FutureOr<void> _onLoadingEvent(
    PlaylistLoadEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    emit(PlaylistLoadingState());

    try {
      final playlist = await playlistsRepository.getPlaylist(playlistId);

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
