part of 'track_progress_cubit.dart';

@freezed
abstract class TrackProgressState with _$TrackProgressState {
  const factory TrackProgressState({
    @Default(0.0) double percentProgress,
    @Default('00:00') String stringProgress,
    @Default('00:00') String stringDuration,
  }) = _TrackProgressState;
}
