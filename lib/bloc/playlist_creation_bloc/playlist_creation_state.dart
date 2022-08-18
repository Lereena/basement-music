abstract class PlaylistCreationState {}

class GettingInputState extends PlaylistCreationState {}

class WaitingCreationState extends PlaylistCreationState {}

class CreatedState extends PlaylistCreationState {}

class InputErrorState extends PlaylistCreationState {
  String errorText;

  InputErrorState(this.errorText);
}

class CreationErrorState extends PlaylistCreationState {}
