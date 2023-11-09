part of 'track_editor_bloc.dart';

abstract class TrackEditorState extends Equatable {
  const TrackEditorState();

  @override
  List<Object> get props => [];
}

class TrackEditorInitial extends TrackEditorState {}

class TrackEditorLoadInProgress extends TrackEditorState {}

class TrackEditorSuccess extends TrackEditorState {}

class TrackEditorError extends TrackEditorState {}
