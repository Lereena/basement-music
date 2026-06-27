import 'package:basement_music/logger.dart';
import 'package:basement_music/models/soulseek_search_result.dart';
import 'package:basement_music/models/soulseek_search_results.dart';
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

  // Bumped on every new search; lets in-flight poll loops detect they're stale.
  int _searchToken = 0;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    _lastQuery = query;
    final token = ++_searchToken;

    emit(const SoulseekSearchState.loading());
    try {
      final ticket = await _repo.startSearch(query);
      if (token != _searchToken) return;

      await _pollResults(ticket, token);
    } on DioException catch (e) {
      if (await _handleConnectionError(e)) return;

      logger.e('Soulseek search failed: $e');
      emit(const SoulseekSearchState.error());
    } catch (e) {
      logger.e('Soulseek search failed: $e');
      emit(const SoulseekSearchState.error());
    }
  }

  /// Polls the daemon for results as peers respond, emitting a growing list each
  /// tick until the collection window closes (done) or the search is superseded.
  Future<void> _pollResults(int ticket, int token) async {
    // Start with an empty in-progress list so the UI shows "searching" at once.
    emit(const SoulseekSearchState.loaded(results: [], searching: true));

    for (var i = 0; i < 20; i++) {
      late final SoulseekSearchResults page;
      try {
        page = await _repo.searchResults(ticket);
      } on DioException catch (e) {
        if (await _handleConnectionError(e)) return;
        rethrow;
      }

      if (token != _searchToken) return;

      final preloads = state.mapOrNull(loaded: (s) => s.preloads) ?? const {};
      emit(SoulseekSearchState.loaded(results: page.results, preloads: preloads, searching: !page.done));

      if (page.done) return;
      await Future.delayed(const Duration(seconds: 1));
      if (token != _searchToken) return;
    }
  }

  /// Handles a 503 from the backend (daemon not connected): surfaces "connecting"
  /// and waits, or reports the failure. Returns true if it handled the error.
  Future<bool> _handleConnectionError(DioException e) async {
    if (e.response?.statusCode != 503) return false;

    final data = e.response?.data;
    final state = (data is Map ? data['state'] : null) as String?;
    final reason = (data is Map ? data['reason'] : null) as String?;

    if (state == 'failed') {
      emit(SoulseekSearchState.connectionFailed(reason: _reasonText(reason)));
    } else {
      await _awaitConnection();
    }
    return true;
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

  void _updatePreload(String key, SoulseekPreload entry) {
    final current = state.mapOrNull(loaded: (s) => s);
    if (current == null) return;
    emit(current.copyWith(preloads: {...current.preloads, key: entry}));
  }

  Future<void> preload(SoulseekSearchResult result) async {
    final key = resultKey(result);

    _updatePreload(key, const SoulseekPreload.loading());

    try {
      final temp = await _repo.preload(result);

      _updatePreload(key, SoulseekPreload.ready(temp));
    } catch (e) {
      logger.e('Soulseek preload failed: $e');

      _updatePreload(key, const SoulseekPreload.error(message: 'Peer refused — try another'));
    }
  }

  Future<void> save(SoulseekSearchResult result, String tempId, String artist, String title) async {
    final key = resultKey(result);

    try {
      await _repo.save(tempId, artist, title);

      _updatePreload(key, const SoulseekPreload.saved());
    } catch (e) {
      logger.e('Soulseek save failed: $e');

      _updatePreload(key, const SoulseekPreload.error(message: 'Failed to save track'));
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
