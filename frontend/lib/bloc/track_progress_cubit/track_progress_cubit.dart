import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:basement_music/audio_player_handler.dart';
import 'package:basement_music/utils/time.dart';

part 'track_progress_cubit.freezed.dart';
part 'track_progress_state.dart';

class TrackProgressCubit extends Cubit<TrackProgressState> {
  final AudioPlayerHandler audioHandler;

  TrackProgressCubit(this.audioHandler) : super(const TrackProgressState()) {
    audioHandler.onPositionChanged.listen((progress) {
      updateProgress(progress);
    });
  }

  bool get canSeek => (audioHandler.mediaItem.value?.duration?.inSeconds ?? 0) > 0;

  void updateProgress(Duration progress) {
    final totalSeconds = audioHandler.mediaItem.value?.duration?.inSeconds ?? 0;
    final percentProgress =
        totalSeconds > 0 ? (progress.inSeconds / totalSeconds).clamp(0.0, 1.0) : 0.0;

    emit(
      state.copyWith(
        percentProgress: percentProgress,
        stringProgress: durationString(progress.inSeconds),
        stringDuration: durationString(totalSeconds),
      ),
    );
  }

  Future<void> seek(double percent) async {
    final total = audioHandler.mediaItem.value?.duration;
    if (total == null || total.inSeconds <= 0) return;

    final target = total * percent.clamp(0.0, 1.0);
    await audioHandler.seek(target);
    // Optimistic update: prevents the slider thumb from snapping back
    // before the position stream catches up.
    updateProgress(target);
  }
}
