part of 'cacher_bloc.dart';

@immutable
class CacherState extends Equatable {
  final Set<String> caching;
  final Set<String> cached;
  final Set<String> unsuccessful;
  final int available;

  const CacherState({
    this.caching = const {},
    this.cached = const {},
    this.unsuccessful = const {},
    this.available = 0,
  });

  @override
  List<Object> get props => [caching, cached, unsuccessful, available];

  bool isCached(List<String> trackIds) {
    return cached.containsAll(trackIds);
  }

  bool isCaching(List<String> trackIds) {
    return caching.containsAll(trackIds);
  }

  CacherState copyWith({
    Set<String>? caching,
    Set<String>? cached,
    Set<String>? unsuccessful,
    int? available,
  }) {
    return CacherState(
      caching: caching ?? this.caching,
      cached: cached ?? this.cached,
      unsuccessful: unsuccessful ?? this.unsuccessful,
      available: available ?? this.available,
    );
  }
}

class CacherInitial extends CacherState {
  const CacherInitial() : super();
}
