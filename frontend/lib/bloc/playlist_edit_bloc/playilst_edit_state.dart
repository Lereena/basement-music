part of 'playilst_edit_bloc.dart';

@immutable
sealed class PlayilstEditState {}

final class PlayilstEditInitial extends PlayilstEditState {}

final class PlayilstEditing extends PlayilstEditState {
  final String playlistId;

  PlayilstEditing(this.playlistId);
}

final class PlayilstSaving extends PlayilstEditState {}

final class PlayilstSavingSuccess extends PlayilstEditState {}

final class PlayilstSavingFail extends PlayilstEditState {}
