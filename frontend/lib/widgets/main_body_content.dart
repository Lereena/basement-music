import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/connectivity_status_bloc/connectivity_status_cubit.dart';
import '../bloc/navigation_cubit/navigation_cubit.dart';
import '../pages/library_page.dart';
import '../pages/playlist_page.dart';
import '../pages/search_page.dart';
import '../pages/settings_page.dart';
import '../pages/tracks_page.dart';
import '../pages/upload/upload_page.dart';
import 'navigations/drawer_navigation_wrapper.dart';

class MainBodyContent extends StatefulWidget {
  final bool narrow;
  final bool drawerNavigation;

  const MainBodyContent({
    super.key,
    this.narrow = false,
    required this.drawerNavigation,
  });

  @override
  State<MainBodyContent> createState() => _MainBodyContentState();
}

class _MainBodyContentState extends State<MainBodyContent> {
  late final StreamSubscription _subscription;

  late final _theme = Theme.of(context);
  late final _flushbar = Flushbar(
    title: 'You are offline',
    message: 'Cached tracks are available to listen',
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(16),
    backgroundColor: _theme.colorScheme.primaryContainer,
    titleColor: _theme.colorScheme.onSurface,
    messageColor: _theme.colorScheme.onSurface,
    forwardAnimationCurve: Curves.easeIn,
    reverseAnimationCurve: Curves.easeOut,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
  );

  @override
  void initState() {
    super.initState();

    _subscription =
        context.read<ConnectivityStatusCubit>().stream.listen(_handleFlushbar);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _handleFlushbar(ConnectivityStatusState status) {
    if (status is NoConnectionState) {
      if (!_flushbar.isShowing()) {
        _flushbar.show(context);
      }
    } else {
      _flushbar.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return DrawerNavigationWrapper(
          drawerNavigation: widget.drawerNavigation,
          pageTitle: _pageTitle(state),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.narrow ? 100 : 10),
            child: _page(state),
          ),
        );
      },
    );
  }

  Widget _page(NavigationState state) {
    if (state is NavigationTracks) return TracksPage();
    if (state is NavigationLibrary) return const LibraryPage();
    if (state is NavigationSearch) return const SearchPage();
    if (state is NavigationArtistsList) return _unimplemented(state);
    if (state is NavigationSettings) return const SettingsPage();
    if (state is NavigationArtist) return _unimplemented(state);
    if (state is NavigationAlbum) return _unimplemented(state);
    if (state is NavigationPlaylist) {
      return PlaylistPage(playlist: state.playlist);
    }
    if (state is NavigationUploadTrack) return const UploadPage();

    return _unimplemented(state);
  }

  String _pageTitle(NavigationState state) {
    if (state is NavigationTracks) return 'All tracks';
    if (state is NavigationLibrary) return 'Library';
    if (state is NavigationSearch) return 'Tracks search';
    if (state is NavigationArtistsList) return 'Artists';
    if (state is NavigationSettings) return 'Settings';
    if (state is NavigationArtist) return '';
    if (state is NavigationAlbum) return '';
    if (state is NavigationPlaylist) return state.playlist.title;
    if (state is NavigationUploadTrack) return 'Upload track';

    return '';
  }

  Widget _unimplemented(NavigationState state) {
    return Center(child: Text('Navigation unimplemented with state: $state'));
  }
}
