abstract class PlaylistCreationEvent {}

class GetInputEvent extends PlaylistCreationEvent {}

class LoadingEvent extends PlaylistCreationEvent {
  final String title;

  LoadingEvent(this.title);
}
