import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../utils/time.dart';
import '../player_bloc/player_bloc.dart';

part 'track_progress_state.dart';

class TrackProgressCubit extends Cubit<TrackProgressState> {
  final PlayerBloc playerBloc;

  TrackProgressCubit(this.playerBloc) : super(const TrackProgressInitial()) {
    playerBloc.onPositionChanged.listen((progress) {
      updateProgress(progress);
    });
  }

  void updateProgress(Duration progress) {
    final percentProgress = progress.inSeconds.toDouble() / playerBloc.state.currentTrack.duration;
    final stringProgress = durationString(progress.inSeconds);

    emit(TrackProgressState(percentProgress, stringProgress));
  }
}
