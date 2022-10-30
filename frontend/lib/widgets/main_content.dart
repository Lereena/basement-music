import 'package:basement_music/enums/pages_enum.dart';
import 'package:basement_music/pages/library_page.dart';
import 'package:basement_music/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/navigation_cubit/navigation_cubit.dart';
import '../pages/home_content_page.dart';
import '../pages/playlist_page.dart';
import '../pages/upload/upload_page.dart';

class MainContent extends StatelessWidget {
  final PageNavigation selectedPage;

  const MainContent({required this.selectedPage}) : super();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          if (state is NavigationHome) return HomeContent();
          if (state is NavigationLibrary) return const LibraryPage();
          if (state is NavigationArtistsList) return _unimplemented(state);
          if (state is NavigationSettings) return const SettingsPage();
          if (state is NavigationArtist) return _unimplemented(state);
          if (state is NavigationAlbum) return _unimplemented(state);
          if (state is NavigationPlaylist) return PlaylistPage(playlist: state.playlist);
          if (state is NavigationUploadTrack) return const UploadPage();

          return _unimplemented(state);
        },
      ),
    );
  }

  Widget _unimplemented(NavigationState state) {
    return Center(child: Text('Navigation unimplemented with state: $state'));
  }
}
