import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../audio_player_handler.dart';
import '../../utils/time.dart';

part 'track_progress_state.dart';

class TrackProgressCubit extends Cubit<TrackProgressState> {
  final AudioPlayerHandler audioHandler;

  TrackProgressCubit(this.audioHandler) : super(const TrackProgressInitial()) {
    audioHandler.onPositionChanged.listen((progress) {
      updateProgress(progress);
    });
  }

  void updateProgress(Duration progress) {
    final percentProgress = progress.inSeconds.toDouble() /
        (audioHandler.mediaItem.value?.duration?.inSeconds ?? 1);
    final stringProgress = durationString(progress.inSeconds);

    emit(TrackProgressState(percentProgress, stringProgress));
  }
}
