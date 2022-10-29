import 'package:basement_music/enums/pages_enum.dart';
import 'package:basement_music/pages/library_page.dart';
import 'package:basement_music/pages/settings_page.dart';
import 'package:flutter/material.dart';

import '../pages/home_content_page.dart';

class MainBodyContent extends StatelessWidget {
  final PageNavigation selectedPage;

  const MainBodyContent({required this.selectedPage}) : super();

  @override
  Widget build(BuildContext context) {
    switch (selectedPage) {
      case PageNavigation.home:
        return HomeContent();
      case PageNavigation.library:
        return const LibraryPage();
      case PageNavigation.settings:
        return const SettingsPage();
    }
  }
}
