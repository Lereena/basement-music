import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../repositories/playlists_repository.dart';
import '../../repositories/tracks_repository.dart';
import '../../utils/log/log_service.dart';

part 'remove_from_playlist_event.dart';
part 'remove_from_playlist_state.dart';

class RemoveFromPlaylistBloc
    extends Bloc<RemoveFromPlaylistEvent, RemoveFromPlaylistState> {
  final TracksRepository _tracksRepository;
  final PlaylistsRepository _playlistsRepository;

  RemoveFromPlaylistBloc(this._tracksRepository, this._playlistsRepository)
      : super(RemoveFromPlaylistInitial()) {
    on<TrackChoosen>(_onTrackChoosen);
    on<ConfirmationReceived>(_onConfirmationReceived);
  }

  FutureOr<void> _onTrackChoosen(
    TrackChoosen event,
    Emitter<RemoveFromPlaylistState> emit,
  ) {
    if (event.trackId.isEmpty ||
        event.playlistId == null ||
        event.playlistId!.isEmpty) {
      emit(RemoveFromPlaylistError());
    } else {
      emit(RemoveFromPlaylistWaitingConfirmation());
    }
  }

  FutureOr<void> _onConfirmationReceived(
    ConfirmationReceived event,
    Emitter<RemoveFromPlaylistState> emit,
  ) async {
    try {
      final result = await _playlistsRepository.removeTrackFromPlaylist(
        event.playlistId!,
        event.trackId,
      );
      emit(RemoveFromPlaylistLoading());

      if (result) {
        _playlistsRepository.items
            .firstWhere((element) => element.id == event.playlistId)
            .tracks
            .remove(
              _tracksRepository.items
                  .firstWhere((element) => element.id == event.trackId),
            );
        emit(RemoveFromPlaylistRemoved());
      } else {
        emit(RemoveFromPlaylistError());
      }
    } catch (e) {
      emit(RemoveFromPlaylistError());
      LogService.log('Error removing track from playlist: $e');
    }
  }
}
