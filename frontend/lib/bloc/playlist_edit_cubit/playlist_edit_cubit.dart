import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/playlists_repository.dart';

part 'playlist_edit_cubit.freezed.dart';
part 'playlist_edit_state.dart';

class PlaylistEditorCubit extends Cubit<PlaylistEditState> {
  final PlaylistsRepository playlistsRepository;
  final String playlistId;

  PlaylistEditorCubit({
    required this.playlistsRepository,
    required this.playlistId,
  }) : super(const PlaylistEditState.initial());

  Future<void> startEditing() async {
    emit(const PlaylistEditState.saveInProgress());

    final playlist = await playlistsRepository.getPlaylist(playlistId);

    emit(PlaylistEditState.editInProgress(
      playlistId: playlist.id,
      title: playlist.title,
      image: playlist.image,
      tracks: playlist.tracks,
    ));
  }

  Future<void> save({
    required String title,
    required List<String> tracksIds,
    List<int>? imageBytes,
    String? imageFilename,
  }) async {
    emit(const PlaylistEditState.saveInProgress());

    try {
      if (imageBytes != null && imageFilename != null) {
        await playlistsRepository.updatePlaylistImage(playlistId, imageBytes, imageFilename);
      }
      await playlistsRepository.editPlaylist(
        id: playlistId,
        title: title,
        tracksIds: tracksIds,
      );
      emit(const PlaylistEditState.success());
    } catch (e) {
      emit(const PlaylistEditState.fail());
      logger.e('Error editing playlist: $e');
    }
  }
}
