part of 'cacher_bloc.dart';

abstract class CacherEvent extends Equatable {
  const CacherEvent();

  @override
  List<Object> get props => [];
}

class CacheTrackEvent extends CacherEvent {
  final String trackId;

  CacheTrackEvent(this.trackId);
}

class CacheTracksEvent extends CacherEvent {
  final List<String> trackIds;

  CacheTracksEvent(this.trackIds);
}

class UncacheTracksEvent extends CacherEvent {
  final List<String> trackIds;

  UncacheTracksEvent(this.trackIds);
}
