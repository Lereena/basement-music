abstract class PlaylistCreationState {
  const PlaylistCreationState();
}

class GettingInputState extends PlaylistCreationState {}

class WaitingCreationState extends PlaylistCreationState {}

class CreatedState extends PlaylistCreationState {}

class InputErrorState extends PlaylistCreationState {
  final String errorText;

  const InputErrorState(this.errorText);
}

class CreationErrorState extends PlaylistCreationState {}
