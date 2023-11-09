part of 'track_from_playlist_remover_bloc.dart';

abstract class TrackFromPlaylistRemoverState {}

class RemoveFromPlaylistInitial extends TrackFromPlaylistRemoverState {}

class TrackFromPlaylistRemoverLoadingInProgress
    extends TrackFromPlaylistRemoverState {}

class TrackFromPlaylistRemoverSuccess extends TrackFromPlaylistRemoverState {}

class TrackFromPlaylistRemoverError extends TrackFromPlaylistRemoverState {}
