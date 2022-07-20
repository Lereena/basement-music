import 'package:basement_music/pages/all_tracks_page.dart';
import 'package:basement_music/pages_enum.dart';
import 'package:flutter/material.dart';

import '../pages/upload/upload_page.dart';

class MainContent extends StatefulWidget {
  final PageNavigation selectedPage;

  MainContent({required this.selectedPage}) : super();

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  @override
  Widget build(BuildContext context) {
    switch (widget.selectedPage) {
      case PageNavigation.AllTracks:
        return AllTracksPage();
      case PageNavigation.Library:
        return Container();
      case PageNavigation.Artists:
        return Container();
      case PageNavigation.Upload:
        return UploadPage();
    }
  }
}
