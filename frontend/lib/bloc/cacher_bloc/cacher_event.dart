part of 'cacher_bloc.dart';

@immutable
sealed class CacherEvent extends Equatable {
  const CacherEvent();

  @override
  List<Object> get props => [];
}

final class CacherValidateStarted extends CacherEvent {}

final class CacherTracksCachingStarted extends CacherEvent {
  final List<String> trackIds;

  const CacherTracksCachingStarted(this.trackIds);
}

final class CacherCacheAllAvailableTracksStarted extends CacherEvent {}

final class CacherRemoveTracksFromCacheStarted extends CacherEvent {
  final List<String> trackIds;

  const CacherRemoveTracksFromCacheStarted(this.trackIds);
}

final class CacherAvailableTracksUpdated extends CacherEvent {
  final int availableTracksCout;

  const CacherAvailableTracksUpdated(this.availableTracksCout);
}

final class CacherClearingStarted extends CacherEvent {}
