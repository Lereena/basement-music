import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/playlist.dart';
import '../../../repositories/playlists_repository.dart';
import '../../repositories/tracks_repository.dart';
import '../../utils/log/log_service.dart';

part 'add_to_playlist_event.dart';
part 'add_to_playlist_state.dart';

class AddToPlaylistBloc extends Bloc<AddToPlaylistEvent, AddToPlaylistState> {
  final TracksRepository _tracksRepository;
  final PlaylistsRepository _playlistsRepository;

  AddToPlaylistBloc(this._tracksRepository, this._playlistsRepository) : super(AddToPlaylistInitial()) {
    on<TrackChoosen>(_onTrackChoosen);
    on<PlaylistChoosen>(_onPlaylistChoosen);
  }

  FutureOr<void> _onTrackChoosen(TrackChoosen event, Emitter<AddToPlaylistState> emit) {
    if (event.trackId.isEmpty) {
      emit(Error());
    } else {
      emit(ChoosePlaylist(_playlistsRepository.items));
    }
  }

  FutureOr<void> _onPlaylistChoosen(PlaylistChoosen event, Emitter<AddToPlaylistState> emit) async {
    if (event.playlistId.isEmpty) {
      emit(Error());
      return;
    }

    try {
      final result = await _playlistsRepository.addTrackToPlaylist(event.playlistId, event.trackId);
      if (result) {
        _playlistsRepository.items
            .firstWhere((element) => element.id == event.playlistId)
            .tracks
            .add(_tracksRepository.items.firstWhere((element) => element.id == event.trackId));
        emit(Added());
      } else {
        emit(Error());
      }
    } catch (e) {
      emit(Error());
      LogService.log('Error adding track to playlist: $e');
    }
  }
}
