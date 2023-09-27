part of 'cacher_bloc.dart';

class CacherState extends Equatable {
  final Set<String> caching;
  final Set<String> cached;
  final Set<String> unsuccessful;

  const CacherState({
    this.caching = const {},
    this.cached = const {},
    this.unsuccessful = const {},
  });

  @override
  List<Object> get props => [caching, cached, unsuccessful];

  bool isCached(List<String> trackIds) {
    return cached.containsAll(trackIds);
  }

  bool isCaching(List<String> trackIds) {
    return caching.containsAll(trackIds);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cached': json.encode(cached.toList()),
    };
  }

  factory CacherState.fromMap(Map<String, dynamic> map) {
    return CacherState(
      cached: (json.decode(map['cached'] as String) as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CacherState.fromJson(String source) =>
      CacherState.fromMap(json.decode(source) as Map<String, dynamic>);

  CacherState copyWith({
    Set<String>? caching,
    Set<String>? cached,
    Set<String>? unsuccessful,
  }) {
    return CacherState(
      caching: caching ?? this.caching,
      cached: cached ?? this.cached,
      unsuccessful: unsuccessful ?? this.unsuccessful,
    );
  }

  @override
  String toString() {
    return 'CacherState(caching: $caching, cached: $cached, unsuccessful: $unsuccessful)';
  }
}

class CacherInitial extends CacherState {
  const CacherInitial() : super();
}
