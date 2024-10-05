import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/artists_bloc/artists_cubit.dart';
import '../../bloc/playlists_bloc/playlists_bloc.dart';
import '../../repositories/artists_repository.dart';
import '../../repositories/repositories.dart';
import '../../routing/routes.dart';
import '../../widgets/artist_card.dart';
import '../../widgets/playlist_card.dart';

part 'artists.dart';
part 'playlists.dart';

enum LibraryPageTab {
  playlists,
  artists;

  String get title => this == LibraryPageTab.artists ? 'Artists' : 'Playlists';

  Future<void> Function(BuildContext) get load => switch (this) {
        LibraryPageTab.playlists => (context) async {
            final playlistsBloc = context.read<PlaylistsBloc>();
            final newState = playlistsBloc.stream.first;
            playlistsBloc.add(PlaylistsLoadStarted());
            await newState;
          },
        LibraryPageTab.artists => (context) async {
            final artistsCubit = context.read<ArtistsCubit>();
            final newState = artistsCubit.stream.first;
            artistsCubit.loadArtists();
            await newState;
          },
      };
}

class LibraryPage extends StatefulWidget {
  final LibraryPageTab initialTab;

  const LibraryPage({super.key, required this.initialTab});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with SingleTickerProviderStateMixin {
  late LibraryPageTab tab = widget.initialTab;
  late final TabController tabController = TabController(
    length: LibraryPageTab.values.length,
    vsync: this,
    initialIndex: LibraryPageTab.values.indexOf(tab),
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
          labelPadding: EdgeInsets.zero,
          labelStyle: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 18,
            letterSpacing: 1.1,
          ),
          tabs: LibraryPageTab.values
              .map(
                (tab) => Tab(
                  text: tab.title,
                  height: 22,
                  iconMargin: EdgeInsets.zero,
                ),
              )
              .toList(),
          onTap: (index) => setState(() => tab = LibraryPageTab.values[index]),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => tab.load(context),
        child: TabBarView(
          controller: tabController,
          children: [
            BlocProvider(
              create: (context) => PlaylistsBloc(
                playlistsRepository: context.read<PlaylistsRepository>(),
                connectivityStatusRepository: context.read<ConnectivityStatusRepository>(),
              )..add(PlaylistsLoadStarted()),
              child: const _Playlists(),
            ),
            BlocProvider(
              create: (context) => ArtistsCubit(
                artistsRepository: context.read<ArtistsRepository>(),
              )..loadArtists(),
              child: const _Artists(),
            ),
          ],
        ),
      ),
    );
  }
}
