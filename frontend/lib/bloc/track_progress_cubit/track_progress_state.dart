part of 'track_progress_cubit.dart';

class TrackProgressState extends Equatable {
  final double percentProgress;
  final String stringProgress;

  const TrackProgressState(this.percentProgress, this.stringProgress);

  @override
  List<Object> get props => [percentProgress];
}

class TrackProgressInitial extends TrackProgressState {
  const TrackProgressInitial() : super(0, '00:00');
}
