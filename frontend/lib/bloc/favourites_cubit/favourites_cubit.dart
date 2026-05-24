import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/favourites_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favourites_cubit.freezed.dart';
part 'favourites_state.dart';

class FavouritesCubit extends Cubit<FavouritesState> {
  FavouritesCubit(this._repo) : super(const FavouritesState.initial());

  final FavouritesRepository _repo;

  Future<void> loadFavourites() async {
    emit(const FavouritesState.loadInProgress());
    try {
      final tracks = await _repo.getFavourites();
      emit(FavouritesState.loaded(tracks: tracks));
    } catch (_) {
      emit(const FavouritesState.error());
    }
  }

  bool isFavourite(String trackId) =>
      state.maybeWhen(loaded: (tracks) => tracks.any((t) => t.id == trackId), orElse: () => false);

  Future<void> toggleFavourite(String trackId) async {
    if (isFavourite(trackId)) {
      await _repo.removeFavourite(trackId);
    } else {
      await _repo.addFavourite(trackId);
    }
    await loadFavourites();
  }
}
