part of 'cacher_bloc.dart';

@immutable
sealed class CacherEvent extends Equatable {
  const CacherEvent();

  @override
  List<Object> get props => [];
}

final class CacherValidateStarted extends CacherEvent {}

final class CacherTrackCachingStarted extends CacherEvent {
  final String trackId;

  const CacherTrackCachingStarted(this.trackId);
}

final class CacherTracksCachingStarted extends CacherEvent {
  final List<String> trackIds;

  const CacherTracksCachingStarted(this.trackIds);
}

final class CacherUncacheTracksStarted extends CacherEvent {
  final List<String> trackIds;

  const CacherUncacheTracksStarted(this.trackIds);
}
