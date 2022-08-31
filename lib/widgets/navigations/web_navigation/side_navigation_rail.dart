import 'package:basement_music/widgets/navigations/web_navigation/playlists_section.dart';
import 'package:flutter/material.dart';

import '../../../enums/pages_enum.dart';
import '../../../routes.dart';
import 'navigation_destination.dart';
import 'rail_theme.dart';

class SideNavigationRail extends StatelessWidget {
  final PageNavigation selectedPage;
  final Function(int) onDestinationSelected;

  const SideNavigationRail({
    super.key,
    required this.selectedPage,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final navigationRailTheme = NavigationRailDefaultsM2(context);

    final backgroundColor = navigationRailTheme.backgroundColor!;
    final elevation = navigationRailTheme.elevation!;

    return Material(
      color: backgroundColor,
      elevation: elevation,
      child: SizedBox(
        width: 300,
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Icon(
                Icons.music_note,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Divider(indent: 10, endIndent: 10),
            SideNavigationDestination(
              icon: const Icon(Icons.home),
              label: 'Home',
              selected: selectedPage == PageNavigation.home,
              onTap: () => onDestinationSelected(0),
            ),
            SideNavigationDestination(
              icon: const Icon(Icons.library_music),
              label: 'Library',
              selected: selectedPage == PageNavigation.library,
              onTap: () => onDestinationSelected(1),
            ),
            const Divider(indent: 10, endIndent: 10),
            const PlaylistsSection(),
            const Divider(indent: 10, endIndent: 10),
            SideNavigationDestination(
              icon: const Icon(Icons.settings),
              label: 'Settings',
              selected: selectedPage == PageNavigation.settings,
              onTap: () => Navigator.pushNamed(context, NavigationRoute.settings.name),
            ),
          ],
        ),
      ),
    );
  }
}
