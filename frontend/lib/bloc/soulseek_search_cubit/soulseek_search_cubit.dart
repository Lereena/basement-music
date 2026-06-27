import 'package:basement_music/logger.dart';
import 'package:basement_music/models/soulseek_search_result.dart';
import 'package:basement_music/models/soulseek_temp_track.dart';
import 'package:basement_music/repositories/soulseek_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'soulseek_search_cubit.freezed.dart';
part 'soulseek_search_state.dart';

class SoulseekSearchCubit extends Cubit<SoulseekSearchState> {
  SoulseekSearchCubit(this._repo) : super(const SoulseekSearchState.initial());

  final SoulseekRepository _repo;

  String _lastQuery = '';

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    _lastQuery = query;

    emit(const SoulseekSearchState.loading());
    try {
      final results = await _repo.search(query);
      emit(SoulseekSearchState.loaded(results: results, preloaded: const []));
    } on DioException catch (e) {
      // 503 means the daemon isn't connected yet -- the backend kicked off a
      // background connect. Surface "connecting" and wait, or report the failure.
      if (e.response?.statusCode == 503) {
        final data = e.response?.data;
        final state = (data is Map ? data['state'] : null) as String?;
        final reason = (data is Map ? data['reason'] : null) as String?;

        if (state == 'failed') {
          emit(SoulseekSearchState.connectionFailed(reason: _reasonText(reason)));
        } else {
          await _awaitConnection();
        }

        return;
      }

      logger.e('Soulseek search failed: $e');
      emit(const SoulseekSearchState.error());
    } catch (e) {
      logger.e('Soulseek search failed: $e');
      emit(const SoulseekSearchState.error());
    }
  }

  /// Polls the connection endpoint while the backend connects, then re-runs the
  /// last search on success or reports the failure with its reason.
  Future<void> _awaitConnection() async {
    emit(const SoulseekSearchState.connecting());

    for (var i = 0; i < 40; i++) {
      await Future.delayed(const Duration(milliseconds: 1500));

      try {
        final conn = await _repo.getConnection();
        if (conn.isConnected) {
          await search(_lastQuery);
          return;
        }

        if (conn.isFailed) {
          emit(SoulseekSearchState.connectionFailed(reason: _reasonText(conn.reason)));
          return;
        }
      } catch (e) {
        logger.e('Soulseek connection poll failed: $e');
      }
    }
    emit(const SoulseekSearchState.connectionFailed(reason: 'Connection timed out'));
  }

  String _reasonText(String? reason) => (reason == null || reason.isEmpty) ? 'Connection failed' : reason;

  Future<void> retry() => search(_lastQuery);

  Future<void> preload(SoulseekSearchResult result) async {
    final current = state.mapOrNull(loaded: (s) => s);
    if (current == null) return;

    emit(current.copyWith(preloadInProgress: true, preloadError: null));
    try {
      final temp = await _repo.preload(result);
      emit(current.copyWith(preloaded: [...current.preloaded, temp], preloadInProgress: false));
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
      emit(current.copyWith(preloaded: current.preloaded.where((t) => t.id != tempId).toList()));
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
