import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:basement_music/logger.dart';
import 'package:basement_music/repositories/artists_repository.dart';

part 'artist_edit_cubit.freezed.dart';
part 'artist_edit_state.dart';

class ArtistEditCubit extends Cubit<ArtistEditState> {
  final ArtistsRepository artistsRepository;
  final String artistId;

  ArtistEditCubit({required this.artistsRepository, required this.artistId}) : super(const ArtistEditState());

  Future<void> startEditing() async {
    emit(state.copyWith(loading: true));
    try {
      final artist = await artistsRepository.getArtist(artistId);
      emit(
        state.copyWith(
          loading: false,
          name: artist.name,
          description: artist.description ?? '',
          currentImageUrl: artist.image,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: true));
      logger.e('Error starting artist edit: $e');
    }
  }

  void setName(String name) => emit(state.copyWith(name: name));

  void setDescription(String description) => emit(state.copyWith(description: description));

  void pickImage(Uint8List bytes, String filename) {
    emit(state.copyWith(pickedBytes: bytes, pickedFilename: filename));
  }

  Future<void> save() async {
    emit(state.copyWith(saving: true));
    try {
      if (state.pickedBytes != null) {
        await artistsRepository.updateArtistImage(artistId, state.pickedBytes!, state.pickedFilename!);
      }
      await artistsRepository.editArtist(id: artistId, name: state.name, description: state.description);
      emit(state.copyWith(saving: false, saved: true));
    } catch (e) {
      emit(state.copyWith(saving: false, error: true));
      logger.e('Error saving artist: $e');
    }
  }
}
