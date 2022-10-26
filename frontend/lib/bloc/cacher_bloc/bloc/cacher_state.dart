part of 'cacher_bloc.dart';

class CacherState extends Equatable {
  final Set<String> caching;
  final Set<String> cached;
  final Set<String> unsuccessful;

  const CacherState(this.caching, this.cached, this.unsuccessful);

  @override
  List<Object> get props => [caching, cached, unsuccessful];

  bool isCached(List<String> trackIds) {
    return cached.containsAll(trackIds);
  }

  bool isCaching(List<String> trackIds) {
    return caching.containsAll(trackIds);
  }
}

class CacherInitial extends CacherState {
  CacherInitial() : super({}, {}, {});
}
