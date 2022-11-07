part of 'remove_from_playlist_cubit.dart';

abstract class RemoveFromPlaylistState {}

class RemoveFromPlaylistInitial extends RemoveFromPlaylistState {}

class RemoveFromPlaylistWaitingConfirmation extends RemoveFromPlaylistState {}

class RemoveFromPlaylistLoading extends RemoveFromPlaylistState {}

class RemoveFromPlaylistRemoved extends RemoveFromPlaylistState {}

class RemoveFromPlaylistError extends RemoveFromPlaylistState {}
