import 'package:basement_music/enums/pages_enum.dart';
import 'package:basement_music/pages/all_tracks_page.dart';
import 'package:basement_music/pages/library_page.dart';
import 'package:flutter/material.dart';

class MainContent extends StatefulWidget {
  final PageNavigation selectedPage;

  const MainContent({required this.selectedPage}) : super();

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  @override
  Widget build(BuildContext context) {
    switch (widget.selectedPage) {
      case PageNavigation.allTracks:
        return const AllTracksPage();
      case PageNavigation.library:
        return const LibraryPage();
      case PageNavigation.artists:
        return Container();
    }
  }
}
