part of 'cacher_cubit.dart';

@freezed
abstract class CacherState with _$CacherState {
  const CacherState._();

  const factory CacherState({
    @Default(<String>{}) Set<String> caching,
    @Default(<String>{}) Set<String> cached,
    @Default(<String>{}) Set<String> unsuccessful,
    @Default(0) int available,
  }) = _CacherState;

  bool isCached(List<String> trackIds) => cached.containsAll(trackIds);
  bool isCaching(List<String> trackIds) => caching.containsAll(trackIds);
}
