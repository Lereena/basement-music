import 'dart:async';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'artists_cubit.freezed.dart';
part 'artists_state.dart';

class ArtistsCubit extends Cubit<ArtistsState> {
  final ArtistsRepository artistsRepository;

  late final StreamSubscription<List<Artist>> _subscription;

  ArtistsCubit({required this.artistsRepository}) : super(const ArtistsState.initial()) {
    // Re-emit whenever the artist list changes (edits, metadata, track rebinds,
    // album changes) so the grid always shows fresh data. skip(1) ignores the
    // BehaviorSubject's replayed current value so it doesn't clobber loadArtists.
    _subscription = artistsRepository.artistsSubject.stream.skip(1).listen(_onArtistsChanged);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  void _onArtistsChanged(List<Artist> artists) {
    if (isClosed) return;
    emit(artists.isEmpty ? const ArtistsState.empty() : ArtistsState.loaded(artists: artists));
  }

  Future<void> uploadArtistImage(String artistId, List<int> bytes, String filename) async {
    await artistsRepository.updateArtistImage(artistId, bytes, filename);
    await loadArtists();
  }

  Future<void> loadArtists() async {
    final oldState = state;
    emit(const ArtistsState.loading());

    try {
      await artistsRepository.getAllArtists();
      if (artistsRepository.items.isEmpty) {
        emit(const ArtistsState.empty());
      } else {
        // Snapshot — never hold the repo's live `_items`, which mutates in place
        // on later getArtist calls and would make the next state compare equal.
        emit(ArtistsState.loaded(artists: List.of(artistsRepository.items)));
      }
    } catch (e) {
      oldState.maybeWhen(
        loaded: (artists) => emit(ArtistsState.loaded(artists: artists)),
        orElse: () => emit(ArtistsState.error(message: e.toString())),
      );
      logger.e('Error loading artists: $e');
    }
  }
}
