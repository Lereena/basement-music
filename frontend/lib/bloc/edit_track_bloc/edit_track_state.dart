part of 'edit_track_bloc.dart';

abstract class EditTrackState extends Equatable {
  const EditTrackState();

  @override
  List<Object> get props => [];
}

class GettingInputState extends EditTrackState {}

class WaitingEditingState extends EditTrackState {}

class EditedState extends EditTrackState {}

class InputErrorState extends EditTrackState {
  final String errorText;

  const InputErrorState(this.errorText);
}

class EditingErrorState extends EditTrackState {}
