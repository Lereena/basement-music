import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/album.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/albums_repository.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/repositories/repositories.dart';

part 'album_edit_cubit.freezed.dart';
part 'album_edit_state.dart';

class AlbumEditCubit extends Cubit<AlbumEditState> {
  final AlbumsRepository albumsRepository;
  final ArtistsRepository artistsRepository;
  final TracksRepository tracksRepository;
  final String albumId;

  AlbumEditCubit({
    required this.albumsRepository,
    required this.artistsRepository,
    required this.tracksRepository,
    required this.albumId,
  }) : super(const AlbumEditState());

  Future<void> startEditing() async {
    emit(state.copyWith(loading: true));
    try {
      final album = await albumsRepository.getAlbum(albumId);

      if (tracksRepository.items.isEmpty) await tracksRepository.getAllTracks();
      if (artistsRepository.items.isEmpty) await artistsRepository.getAllArtists();

      emit(
        state.copyWith(
          loading: false,
          album: album,
          title: album.title,
          year: album.year?.toString() ?? '',
          allTracks: List.of(tracksRepository.items),
          allArtists: List.of(artistsRepository.items),
          orderedTrackIds: album.tracks.map((t) => t.id).toList(),
          selectedArtistIds: album.artists?.map((a) => a.id).toList() ?? [],
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: true));
      logger.e('Error starting album edit: $e');
    }
  }

  void setTitle(String title) => emit(state.copyWith(title: title));

  void setYear(String year) => emit(state.copyWith(year: year));

  void toggleArtist(String artistId) {
    final ids = List.of(state.selectedArtistIds);
    ids.contains(artistId) ? ids.remove(artistId) : ids.add(artistId);
    emit(state.copyWith(selectedArtistIds: ids));
  }

  void toggleTrack(String trackId) {
    final ids = List.of(state.orderedTrackIds);
    ids.contains(trackId) ? ids.remove(trackId) : ids.add(trackId);
    emit(state.copyWith(orderedTrackIds: ids));
  }

  void reorder(int oldIndex, int newIndex) {
    final ids = List.of(state.orderedTrackIds);
    if (newIndex > oldIndex) newIndex -= 1;
    final id = ids.removeAt(oldIndex);
    ids.insert(newIndex, id);
    emit(state.copyWith(orderedTrackIds: ids));
  }

  void pickCover(Uint8List bytes, String filename) {
    emit(state.copyWith(pickedCoverBytes: bytes, pickedCoverFilename: filename));
  }

  Future<void> save() async {
    emit(state.copyWith(saving: true));
    try {
      await albumsRepository.editAlbum(id: albumId, title: state.title, year: state.year);
      await albumsRepository.setAlbumArtists(albumId, state.selectedArtistIds);
      await albumsRepository.setAlbumTracks(albumId, state.orderedTrackIds);
      if (state.pickedCoverBytes != null) {
        await albumsRepository.updateAlbumImage(albumId, state.pickedCoverBytes!, state.pickedCoverFilename!);
      }
      emit(state.copyWith(saving: false, saved: true));
    } catch (e) {
      emit(state.copyWith(saving: false, error: true));
      logger.e('Error saving album: $e');
    }
  }
}
