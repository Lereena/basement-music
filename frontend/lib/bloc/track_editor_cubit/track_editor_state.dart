part of 'track_editor_cubit.dart';

@freezed
abstract class TrackEditorState with _$TrackEditorState {
  const factory TrackEditorState.initial() = _Initial;
  const factory TrackEditorState.loadInProgress() = _LoadInProgress;
  const factory TrackEditorState.success({@Default('Track was successfully edited') String message}) = _Success;
  const factory TrackEditorState.error() = _Error;
}
