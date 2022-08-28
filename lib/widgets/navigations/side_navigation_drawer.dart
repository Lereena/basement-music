import 'package:basement_music/enums/pages_enum.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

class SideNavigationDrawer extends StatelessWidget {
  final PageNavigation selectedPage;
  final Function(int) onDestinationSelected;

  const SideNavigationDrawer({
    Key? key,
    required this.selectedPage,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('All tracks'),
            selected: selectedPage == PageNavigation.allTracks,
            onTap: () => onDestinationSelected(0),
          ),
          ListTile(
            leading: const Icon(Icons.featured_play_list_outlined),
            title: const Text('Library'),
            selected: selectedPage == PageNavigation.library,
            onTap: () => onDestinationSelected(1),
          ),
          // ListTile(
          //   leading: Icon(Icons.person_pin_sharp),
          //   title: const Text('Artists'),
          //   selected: selectedPage == PageNavigation.artists,
          //   onTap: () => onDestinationSelected(2),
          // ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings, size: 30),
            title: const Text('Settings'),
            onTap: () => Navigator.pushNamed(context, NavigationRoute.settings.name),
          ),
        ],
      ),
    );
  }
}
