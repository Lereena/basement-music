import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/playlist.dart';
import '../../../repositories/playlists_repository.dart';
import '../../logger.dart';
import '../../repositories/tracks_repository.dart';

part 'add_to_playlist_event.dart';
part 'add_to_playlist_state.dart';

class AddToPlaylistBloc extends Bloc<AddToPlaylistEvent, AddToPlaylistState> {
  final TracksRepository _tracksRepository;
  final PlaylistsRepository _playlistsRepository;

  AddToPlaylistBloc(this._tracksRepository, this._playlistsRepository)
      : super(AddToPlaylistInitial()) {
    on<TrackChoosen>(_onTrackChoosen);
    on<PlaylistChoosen>(_onPlaylistChoosen);
  }

  FutureOr<void> _onTrackChoosen(
    TrackChoosen event,
    Emitter<AddToPlaylistState> emit,
  ) {
    if (event.trackId.isEmpty) {
      emit(Error());
    } else {
      emit(ChoosePlaylist(_playlistsRepository.items));
    }
  }

  FutureOr<void> _onPlaylistChoosen(
    PlaylistChoosen event,
    Emitter<AddToPlaylistState> emit,
  ) async {
    if (event.playlistId.isEmpty) {
      emit(Error());
      return;
    }

    try {
      await _playlistsRepository.addTrackToPlaylist(
        event.playlistId,
        event.trackId,
      );
      emit(Loading());

      _playlistsRepository.items
          .firstWhere((element) => element.id == event.playlistId)
          .tracks
          .add(
            _tracksRepository.items
                .firstWhere((element) => element.id == event.trackId),
          );
      emit(Added());
    } catch (e) {
      emit(Error());
      logger.e('Error adding track to playlist: $e');
    }
  }
}
