import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/listen_event.dart';
import 'package:basement_music/repositories/connectivity_status_repository.dart';
import 'package:basement_music/rest_client.dart';

class StatsRepository {
  static const _pendingKey = 'pending';
  static const _openSessionKey = 'open_session';
  static const _maxPending = 1000;

  final RestClient _restClient;
  final ConnectivityStatusRepository _connectivityStatusRepository;
  final Box<String> _persistenceBox;

  final _pending = <ListenEvent>[];
  bool _flushing = false;

  StatsRepository(
    this._restClient,
    this._connectivityStatusRepository, {
    required Box<String> persistenceBox,
  }) : _persistenceBox = persistenceBox {
    final cached = _persistenceBox.get(_pendingKey);
    if (cached != null) {
      try {
        _pending.addAll(
          (jsonDecode(cached) as List).map((e) => ListenEvent.fromJson(e as Map<String, dynamic>)),
        );
      } catch (e) {
        _persistenceBox.delete(_pendingKey);
        logger.w('Listen stats pending cache decode failed, cleared: $e');
      }
    }

    _recoverOpenSession();

    _connectivityStatusRepository.statusSubject.listen((status) {
      if (!status.contains(ConnectivityResult.none)) {
        tryFlush();
      }
    });

    tryFlush();
  }

  void _recoverOpenSession() {
    final cached = _persistenceBox.get(_openSessionKey);
    if (cached == null) return;

    try {
      final json = jsonDecode(cached) as Map<String, dynamic>;
      final durationMs = json['duration_ms'] as int;
      if (durationMs > 4000) {
        addFinalized(
          ListenEvent(
            clientEventId: json['client_event_id'] as String,
            trackId: json['track_id'] as String,
            durationMs: durationMs,
            startedAt: DateTime.parse(json['started_at'] as String),
          ),
        );
      }
    } catch (e) {
      logger.w('Listen stats open session recovery failed: $e');
    } finally {
      _persistenceBox.delete(_openSessionKey);
    }
  }

  void addFinalized(ListenEvent event) {
    _pending.add(event);
    if (_pending.length > _maxPending) {
      _pending.removeRange(0, _pending.length - _maxPending);
    }
    _persistPending();
    tryFlush();
  }

  void saveOpenSession({
    required String clientEventId,
    required String trackId,
    required DateTime startedAt,
    required int durationMs,
  }) {
    _persistenceBox.put(
      _openSessionKey,
      jsonEncode({
        'client_event_id': clientEventId,
        'track_id': trackId,
        'started_at': startedAt.toIso8601String(),
        'duration_ms': durationMs,
      }),
    );
  }

  void clearOpenSession() {
    _persistenceBox.delete(_openSessionKey);
  }

  Future<void> tryFlush() async {
    if (_flushing) return;
    if (_pending.isEmpty) return;
    if (_connectivityStatusRepository.statusSubject.value.contains(ConnectivityResult.none)) return;

    _flushing = true;
    try {
      final batch = List<ListenEvent>.from(_pending);
      await _restClient.postListens(batch.map((e) => e.toJson()).toList());
      _pending.removeWhere((e) => batch.any((b) => b.clientEventId == e.clientEventId));
      _persistPending();
    } catch (e) {
      logger.w('Listen stats flush failed, will retry: $e');
    } finally {
      _flushing = false;
    }
  }

  void _persistPending() {
    _persistenceBox.put(_pendingKey, jsonEncode(_pending.map((e) => e.toJson()).toList()));
  }

  // Best-effort push before sign-out, then drop whatever's left — next login
  // starts a fresh queue rather than carrying over the previous user's data.
  Future<void> flushAndClearForSignOut() async {
    await tryFlush();
    _pending.clear();
    _persistenceBox.delete(_pendingKey);
    clearOpenSession();
  }
}
