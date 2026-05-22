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

  void updateProgress(Duration progress) {
    final percentProgress = progress.inSeconds.toDouble() /
        (audioHandler.mediaItem.value?.duration?.inSeconds ?? 1);
    final stringProgress = durationString(progress.inSeconds);

    emit(TrackProgressState(percentProgress: percentProgress, stringProgress: stringProgress));
  }
}
