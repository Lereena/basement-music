abstract class PlaylistCreationState {
  const PlaylistCreationState();
}

class GettingInputState extends PlaylistCreationState {}

class WaitingCreationState extends PlaylistCreationState {}

class CreatedState extends PlaylistCreationState {}

class CreationErrorState extends PlaylistCreationState {}
