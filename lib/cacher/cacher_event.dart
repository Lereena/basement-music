import 'caching_state.dart';

class CacherEvent {
  final CachingState type;
  final String trackId;

  CacherEvent(this.type, this.trackId);
}
