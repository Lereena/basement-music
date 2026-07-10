part of 'listen_stats_cubit.dart';

@freezed
abstract class ListenStatsState with _$ListenStatsState {
  const factory ListenStatsState.initial() = _Initial;
  const factory ListenStatsState.loading() = _Loading;
  const factory ListenStatsState.loaded({required ListenStatsPage page}) = _Loaded;
  const factory ListenStatsState.error() = _Error;
}
