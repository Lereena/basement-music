import 'package:basement_music/logger.dart';
import 'package:basement_music/models/soulseek_search_result.dart';
import 'package:basement_music/models/soulseek_temp_track.dart';
import 'package:basement_music/repositories/soulseek_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'soulseek_search_cubit.freezed.dart';
part 'soulseek_search_state.dart';

class SoulseekSearchCubit extends Cubit<SoulseekSearchState> {
  SoulseekSearchCubit(this._repo) : super(const SoulseekSearchState.initial());

  final SoulseekRepository _repo;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    emit(const SoulseekSearchState.loading());
    try {
      final results = await _repo.search(query);
      emit(SoulseekSearchState.loaded(results: results, preloaded: const []));
    } catch (e) {
      logger.e('Soulseek search failed: $e');
      emit(const SoulseekSearchState.error());
    }
  }

  Future<void> preload(SoulseekSearchResult result) async {
    final current = state.mapOrNull(loaded: (s) => s);
    if (current == null) return;

    emit(current.copyWith(preloadInProgress: true, preloadError: null));
    try {
      final temp = await _repo.preload(result);
      emit(current.copyWith(
        preloaded: [...current.preloaded, temp],
        preloadInProgress: false,
      ));
    } catch (e) {
      logger.e('Soulseek preload failed: $e');
      emit(current.copyWith(preloadInProgress: false, preloadError: 'Peer refused — try another'));
    }
  }

  Future<void> save(String tempId) async {
    final current = state.mapOrNull(loaded: (s) => s);
    if (current == null) return;

    try {
      await _repo.save(tempId);
      emit(current.copyWith(
        preloaded: current.preloaded.where((t) => t.id != tempId).toList(),
      ));
    } catch (e) {
      logger.e('Soulseek save failed: $e');
      emit(current.copyWith(preloadError: 'Failed to save track'));
    }
  }

  Future<void> cleanup() async {
    try {
      await _repo.cleanup();
    } catch (e) {
      logger.e('Soulseek cleanup failed: $e');
    }
  }
}
