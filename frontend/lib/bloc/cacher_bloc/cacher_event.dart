part of 'cacher_bloc.dart';

abstract class CacherEvent extends Equatable {
  const CacherEvent();

  @override
  List<Object> get props => [];
}

class CacheValidateEvent extends CacherEvent {}

class CacheTrackEvent extends CacherEvent {
  final String trackId;

  const CacheTrackEvent(this.trackId);
}

class CacheTracksEvent extends CacherEvent {
  final List<String> trackIds;

  const CacheTracksEvent(this.trackIds);
}

class RemoveTracksFromCacheEvent extends CacherEvent {
  final List<String> trackIds;

  const RemoveTracksFromCacheEvent(this.trackIds);
}
