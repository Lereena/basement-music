import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:basement_music/logger.dart';
import 'package:basement_music/models/artist.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/repositories/repositories.dart';

part 'search_cubit.freezed.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final TracksRepository tracksRepository;
  final PlaylistsRepository playlistsRepository;
  final ArtistsRepository artistsRepository;
  final ConnectivityStatusRepository connectivityStatusRepository;

  SearchCubit({
    required this.tracksRepository,
    required this.playlistsRepository,
    required this.artistsRepository,
    required this.connectivityStatusRepository,
  }) : super(const SearchState.initial());

  Playlist get openedPlaylist => playlistsRepository.openedPlaylist;

  String lastSearch = '';

  Future<void> onSearch(String searchQuery) async {
    final query = searchQuery.trim();
    if (lastSearch == query) return;
    lastSearch = query;

    if (query.isEmpty) {
      emit(const SearchState.initial());
      return;
    }

    emit(SearchState.loadInProgress(query: query));

    try {
      final List<Artist> artists;
      final List<Playlist> playlists;
      final List<Track> tracks;

      if (connectivityStatusRepository.statusSubject.value.contains(ConnectivityResult.none)) {
        // Offline: filter whatever is cached in memory, no server round-trips.
        final lcaseQuery = query.toLowerCase();
        artists = artistsRepository.items.where((a) => a.name.toLowerCase().contains(lcaseQuery)).toList();
        playlists = playlistsRepository.items.where((p) => p.title.toLowerCase().contains(lcaseQuery)).toList();
        tracksRepository.searchTracksOffline(query);
        tracks = tracksRepository.searchItems;
      } else {
        // Online: search runs on the server for all three, in parallel
        // (kick off all requests, then await each).
        final artistsFuture = artistsRepository.searchArtists(query);
        final playlistsFuture = playlistsRepository.searchPlaylists(query);
        final tracksFuture = tracksRepository.searchTracksOnline(query);
        artists = await artistsFuture;
        playlists = await playlistsFuture;
        await tracksFuture;
        tracks = tracksRepository.searchItems;
      }

      if (artists.isEmpty && playlists.isEmpty && tracks.isEmpty) {
        emit(SearchState.successEmpty(query: query));
        return;
      }

      playlistsRepository.openedPlaylist = Playlist.anonymous(tracks);
      emit(SearchState.success(query: query, artists: artists, playlists: playlists, tracks: tracks));
    } catch (e) {
      emit(const SearchState.error());
      logger.e('Error searching: $e');
    }
  }
}
