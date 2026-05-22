part of 'player_cubit.dart';

@freezed
abstract class PlayerState with _$PlayerState {
  const PlayerState._();

  const factory PlayerState.initial({required Track currentTrack}) = _Initial;
  const factory PlayerState.play({required Track currentTrack}) = _Play;
  const factory PlayerState.pause({required Track currentTrack}) = _Pause;

  bool get isInitial => maybeMap(initial: (_) => true, orElse: () => false);
  bool get isPlay => maybeMap(play: (_) => true, orElse: () => false);
  bool get isPause => maybeMap(pause: (_) => true, orElse: () => false);
}
