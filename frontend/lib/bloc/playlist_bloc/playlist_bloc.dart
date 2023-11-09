import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../logger.dart';
import '../../models/playlist.dart';
import '../../repositories/playlists_repository.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final PlaylistsRepository playlistsRepository;

  PlaylistBloc({required this.playlistsRepository}) : super(PlaylistInitial()) {
    on<PlaylistLoadEvent>(_onLoadingEvent);
    on<PlaylistsUpdatedEvent>(_onUpdatedEvent);
  }

  FutureOr<void> _onLoadingEvent(
    PlaylistLoadEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    emit(PlaylistLoadingState());

    try {
      final playlist = await playlistsRepository.getPlaylist(event.playlistId);

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

  FutureOr<void> _onUpdatedEvent(
    PlaylistsUpdatedEvent event,
    Emitter<PlaylistState> emit,
  ) async {
    if (state is! PlaylistLoadedState) return;

    add(PlaylistLoadEvent((state as PlaylistLoadedState).playlist.id));
  }
}
