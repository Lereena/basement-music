import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:uuid/uuid.dart';

import 'package:basement_music/audio_player_handler.dart';
import 'package:basement_music/models/listen_event.dart';
import 'package:basement_music/repositories/stats_repository.dart';

const _persistIntervalSeconds = 15;

class _OpenSession {
  final String clientEventId;
  final String trackId;
  final DateTime startedAt;
  final Stopwatch stopwatch = Stopwatch();

  _OpenSession({required this.clientEventId, required this.trackId, required this.startedAt});
}

// Hooks AudioPlayerHandler, not PlayerCubit: OS-notification skips call
// handler.skipToNext() directly, bypassing the cubit. Handler streams are
// the complete source of truth for what's actually playing.
class ListenTracker {
  final AudioPlayerHandler _audioHandler;
  final StatsRepository _statsRepository;

  _OpenSession? _session;
  Timer? _persistTimer;
  StreamSubscription? _mediaItemSub;
  StreamSubscription? _playerStateSub;

  ListenTracker(this._audioHandler, this._statsRepository) {
    _mediaItemSub = _audioHandler.mediaItem.listen(_onMediaItemChanged);
    _playerStateSub = _audioHandler.onPlayerStateChanged.listen(_onPlayerStateChanged);
    _persistTimer = Timer.periodic(const Duration(seconds: _persistIntervalSeconds), (_) => _persistOpenSession());
  }

  void _onMediaItemChanged(MediaItem? mediaItem) {
    final newTrackId = mediaItem?.id;
    if (newTrackId == _session?.trackId) return;

    _finalize();

    if (newTrackId == null || _audioHandler.isPreview) return;

    _session = _OpenSession(clientEventId: const Uuid().v4(), trackId: newTrackId, startedAt: DateTime.now().toUtc());
  }

  void _onPlayerStateChanged(PlayerState state) {
    switch (state) {
      case PlayerState.playing:
        if (_session == null && !_audioHandler.isPreview) {
          final trackId = _audioHandler.mediaItem.valueOrNull?.id;
          if (trackId != null) {
            _session = _OpenSession(clientEventId: const Uuid().v4(), trackId: trackId, startedAt: DateTime.now().toUtc());
          }
        }
        _session?.stopwatch.start();
      case PlayerState.paused:
        _session?.stopwatch.stop();
        _persistOpenSession();
      case PlayerState.completed:
        _finalize();
      case PlayerState.stopped:
      case PlayerState.disposed:
        break;
    }
  }

  void _persistOpenSession() {
    final session = _session;
    if (session == null) return;

    _statsRepository.saveOpenSession(
      clientEventId: session.clientEventId,
      trackId: session.trackId,
      startedAt: session.startedAt,
      durationMs: session.stopwatch.elapsedMilliseconds,
    );
  }

  void _finalize() {
    final session = _session;
    _session = null;
    if (session == null) return;

    session.stopwatch.stop();
    if (session.stopwatch.elapsedMilliseconds > minListenDurationMs) {
      _statsRepository.addFinalized(
        ListenEvent(
          clientEventId: session.clientEventId,
          trackId: session.trackId,
          durationMs: session.stopwatch.elapsedMilliseconds,
          startedAt: session.startedAt,
        ),
      );
    }
    _statsRepository.clearOpenSession();
  }

  void dispose() {
    _mediaItemSub?.cancel();
    _playerStateSub?.cancel();
    _persistTimer?.cancel();
  }
}
