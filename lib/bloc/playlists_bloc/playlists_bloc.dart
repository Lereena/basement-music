import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/playlists_repository.dart';
import '../../utils/log/log_service.dart';
import 'playlists_event.dart';
import 'playlists_state.dart';

class PlaylistsBloc extends Bloc<PlaylistsEvent, PlaylistsState> {
  final PlaylistsRepository _playlistsRepository;

  PlaylistsBloc(this._playlistsRepository) : super(PlaylistsLoadingState()) {
    on<PlaylistsLoadEvent>(_onLoadingEvent);
  }

  FutureOr<void> _onLoadingEvent(PlaylistsLoadEvent event, Emitter<PlaylistsState> emit) async {
    emit(PlaylistsLoadingState());

    try {
      await _playlistsRepository.getAllPlaylists();

      if (_playlistsRepository.items.isEmpty)
        emit(PlaylistsEmptyState());
      else
        emit(PlaylistsLoadedState(_playlistsRepository.items));
    } catch (e) {
      emit(PlaylistsErrorState());
      LogService.log('Error loading playlists: $e');
    }
  }
}
