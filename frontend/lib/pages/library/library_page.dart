import 'package:basement_music/bloc/artists_cubit/artists_cubit.dart';
import 'package:basement_music/bloc/connectivity_status_cubit/connectivity_status_cubit.dart';
import 'package:basement_music/bloc/favourites_cubit/favourites_cubit.dart';
import 'package:basement_music/bloc/playlists_cubit/playlists_cubit.dart';
import 'package:basement_music/bloc/settings_cubit/settings_cubit.dart';
import 'package:basement_music/bloc/tracks_cubit/tracks_cubit.dart';
import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/repositories/artists_repository.dart';
import 'package:basement_music/repositories/repositories.dart';
import 'package:basement_music/routing/routes.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/widgets/artist_card.dart';
import 'package:basement_music/widgets/create_playlist.dart';
import 'package:basement_music/widgets/playlist_card.dart';
import 'package:basement_music/widgets/track_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'all_tracks.dart';
part 'artists.dart';
part 'favourites.dart';
part 'playlists.dart';

enum LibraryPageTab {
  allTracks,
  favourites,
  playlists,
  artists;

  String get title => switch (this) {
    LibraryPageTab.allTracks => 'All tracks',
    LibraryPageTab.playlists => 'Playlists',
    LibraryPageTab.artists => 'Artists',
    LibraryPageTab.favourites => 'Favourites',
  };

  Future<void> Function(BuildContext) get load => switch (this) {
    LibraryPageTab.allTracks => (context) async {
      final tracksCubit = context.read<TracksCubit>();
      final newState = tracksCubit.stream.first;
      tracksCubit.loadTracks();
      await newState;
    },
    LibraryPageTab.playlists => (context) async {
      final playlistsCubit = context.read<PlaylistsCubit>();
      final newState = playlistsCubit.stream.first;
      playlistsCubit.loadPlaylists();
      await newState;
    },
    LibraryPageTab.artists => (context) async {
      final artistsCubit = context.read<ArtistsCubit>();
      final newState = artistsCubit.stream.first;
      artistsCubit.loadArtists();
      await newState;
    },
    LibraryPageTab.favourites => (context) async {
      final favouritesCubit = context.read<FavouritesCubit>();
      final newState = favouritesCubit.stream.first;
      favouritesCubit.loadFavourites();
      await newState;
    },
  };
}

class LibraryPage extends StatelessWidget {
  final LibraryPageTab initialTab;

  const LibraryPage({super.key, required this.initialTab});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (prev, curr) => prev.homePage != curr.homePage,
      builder: (_, settings) {
        final tabs = settings.homePage == HomePage.favourites
            ? [LibraryPageTab.allTracks, LibraryPageTab.playlists, LibraryPageTab.artists]
            : [LibraryPageTab.favourites, LibraryPageTab.playlists, LibraryPageTab.artists];
        return _LibraryPageContent(
          key: ValueKey(settings.homePage),
          tabs: tabs,
          initialTab: tabs.contains(initialTab) ? initialTab : tabs.first,
        );
      },
    );
  }
}

class _LibraryPageContent extends StatefulWidget {
  final List<LibraryPageTab> tabs;
  final LibraryPageTab initialTab;

  const _LibraryPageContent({super.key, required this.tabs, required this.initialTab});

  @override
  State<_LibraryPageContent> createState() => _LibraryPageContentState();
}

class _LibraryPageContentState extends State<_LibraryPageContent> with SingleTickerProviderStateMixin {
  late LibraryPageTab tab = widget.initialTab;

  late final TabController tabController = TabController(
    length: widget.tabs.length,
    vsync: this,
    initialIndex: widget.tabs.indexOf(tab),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: theme.primaryColor,
          labelColor: theme.primaryColor,
          padding: EdgeInsets.zero,
          labelPadding: EdgeInsets.symmetric(vertical: 8),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          labelStyle: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 18,
            letterSpacing: 1.1,
          ),
          tabs: widget.tabs
              .map((tab) => Tab(text: tab.title, height: 28, iconMargin: EdgeInsets.zero))
              .toList(),
          onTap: (index) => setState(() => tab = widget.tabs[index]),
        ),
      ),
      floatingActionButton: tab == LibraryPageTab.playlists
          ? FloatingActionButton(
              onPressed: () => CreatePlaylistDialog.show(context: context),
              child: const Icon(Icons.add),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () => tab.load(context),
        child: HorizontalSpaceReducer(
          child: TabBarView(
            controller: tabController,
            children: widget.tabs.map(_buildTabView).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabView(LibraryPageTab t) => switch (t) {
    LibraryPageTab.allTracks => const _AllTracks(),
    LibraryPageTab.favourites => const _Favourites(),
    LibraryPageTab.playlists => BlocProvider(
      create: (context) => PlaylistsCubit(
        playlistsRepository: context.read<PlaylistsRepository>(),
        connectivityStatusRepository: context.read<ConnectivityStatusRepository>(),
      )..loadPlaylists(),
      child: const _Playlists(),
    ),
    LibraryPageTab.artists => BlocProvider(
      create: (context) => ArtistsCubit(artistsRepository: context.read<ArtistsRepository>())..loadArtists(),
      child: const _Artists(),
    ),
  };
}
