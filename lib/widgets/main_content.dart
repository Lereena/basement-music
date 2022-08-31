import 'package:basement_music/enums/pages_enum.dart';
import 'package:basement_music/pages/all_tracks_page.dart';
import 'package:basement_music/pages/library_page.dart';
import 'package:flutter/material.dart';

class MainContent extends StatelessWidget {
  final PageNavigation selectedPage;

  const MainContent({required this.selectedPage}) : super();

  @override
  Widget build(BuildContext context) {
    switch (selectedPage) {
      case PageNavigation.home:
        return const AllTracksPage();
      case PageNavigation.library:
        return const LibraryPage();
      case PageNavigation.settings:
        return Container();
    }
  }
}
