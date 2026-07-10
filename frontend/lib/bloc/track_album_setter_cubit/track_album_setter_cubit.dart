import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/album.dart';
import 'package:basement_music/repositories/albums_repository.dart';

part 'track_album_setter_cubit.freezed.dart';
part 'track_album_setter_state.dart';

class TrackAlbumSetterCubit extends Cubit<TrackAlbumSetterState> {
  final AlbumsRepository albumsRepository;
  final String trackId;

  TrackAlbumSetterCubit({required this.albumsRepository, required this.trackId})
    : super(const TrackAlbumSetterState.loading());

  Future<void> loadAlbums() async {
    emit(const TrackAlbumSetterState.loading());
    try {
      final albums = await albumsRepository.getAllAlbums();
      emit(TrackAlbumSetterState.selectInProgress(albums: albums));
    } catch (e) {
      emit(const TrackAlbumSetterState.error());
      logger.e('Error loading albums: $e');
    }
  }

  Future<void> selectAlbum(String albumId) async {
    try {
      emit(const TrackAlbumSetterState.loading());
      await albumsRepository.setTrackAlbum(trackId, albumId);
      emit(const TrackAlbumSetterState.success());
    } catch (e) {
      emit(const TrackAlbumSetterState.error());
      logger.e('Error setting track album: $e');
    }
  }
}
