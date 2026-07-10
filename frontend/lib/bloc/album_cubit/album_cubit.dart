import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/album.dart';
import 'package:basement_music/repositories/albums_repository.dart';

part 'album_cubit.freezed.dart';
part 'album_state.dart';

class AlbumCubit extends Cubit<AlbumState> {
  final AlbumsRepository albumsRepository;
  final String albumId;

  AlbumCubit({required this.albumsRepository, required this.albumId}) : super(const AlbumState.initial());

  Future<void> loadAlbum() async {
    emit(const AlbumState.loading());
    try {
      final album = await albumsRepository.getAlbum(albumId);
      emit(AlbumState.loaded(album: album));
    } catch (e) {
      emit(const AlbumState.error());
      logger.e('Error loading album: $e');
    }
  }

  Future<void> deleteAlbum() async {
    try {
      await albumsRepository.deleteAlbum(albumId);
    } catch (e) {
      emit(const AlbumState.error());
      logger.e('Error deleting album: $e');
    }
  }
}
