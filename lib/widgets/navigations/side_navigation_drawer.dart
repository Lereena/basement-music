import 'package:basement_music/enums/pages_enum.dart';
import 'package:flutter/material.dart';

class SideNavigationDrawer extends StatelessWidget {
  final PageNavigation selectedPage;
  final Function(int) onDestinationSelected;

  const SideNavigationDrawer({
    super.key,
    required this.selectedPage,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Home'),
            selected: selectedPage == PageNavigation.home,
            onTap: () => onDestinationSelected(0),
          ),
          ListTile(
            leading: const Icon(Icons.featured_play_list_outlined),
            title: const Text('Library'),
            selected: selectedPage == PageNavigation.library,
            onTap: () => onDestinationSelected(1),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings, size: 30),
            title: const Text('Settings'),
            selected: selectedPage == PageNavigation.settings,
            onTap: () => onDestinationSelected(2),
          ),
        ],
      ),
    );
  }
}
