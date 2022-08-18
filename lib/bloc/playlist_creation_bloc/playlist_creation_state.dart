abstract class PlaylistCreationState {}

class GettingInputState extends PlaylistCreationState {}

class WaitingCreationState extends PlaylistCreationState {}

class CreatedState extends PlaylistCreationState {}

class ErrorState extends PlaylistCreationState {}
