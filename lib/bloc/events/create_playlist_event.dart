abstract class CreatePlaylistEvent {}

class GetInputEvent extends CreatePlaylistEvent {}

class LoadingCreatePlaylistEvent extends CreatePlaylistEvent {
  final String title;

  LoadingCreatePlaylistEvent(this.title);
}
