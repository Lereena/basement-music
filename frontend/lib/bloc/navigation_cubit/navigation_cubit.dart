import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../models/playlist.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationHome());

  void navigateHome() => emit(NavigationHome());

  void navigateLibrary() => emit(NavigationLibrary());

  void navigateArtistsList() => emit(NavigationArtistsList());

  void navigateSettings() => emit(NavigationSettings());

  void navigateArtist(String artistId) => emit(NavigationArtist(artistId));

  void navigateAlbum(String albumId) => emit(NavigationAlbum(albumId));

  void navigatePlaylist(Playlist playlist) => emit(NavigationPlaylist(playlist));

  void navigateUploadTrack() => emit(NavigationUploadTrack());
}