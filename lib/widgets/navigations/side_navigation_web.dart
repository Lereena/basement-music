import 'package:basement_music/models/playlist.dart';
import 'package:basement_music/widgets/playlist_card.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

class SideNavigationWeb extends StatelessWidget {
  const SideNavigationWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          NavigationDestination(
            icon: const Icon(Icons.home),
            label: 'Home',
            selected: false,
            onTap: () {},
          ),
          NavigationDestination(
            icon: const Icon(Icons.library_music),
            label: 'Library',
            selected: false,
            onTap: () {},
          ),
          const Divider(indent: 10, endIndent: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              PlaylistCard(playlist: Playlist(id: '', tracks: [], title: 'Playlist 1')),
              PlaylistCard(playlist: Playlist(id: '', tracks: [], title: 'Playlist 2')),
              PlaylistCard(playlist: Playlist(id: '', tracks: [], title: 'Playlist 3')),
            ],
          ),
          const Spacer(),
          const Divider(indent: 10, endIndent: 10),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: 'Settings',
            selected: false,
            onTap: () => Navigator.pushNamed(context, NavigationRoute.settings.name),
          ),
        ],
      ),
    );
  }
}

class NavigationDestination extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool selected;
  final Function() onTap;

  const NavigationDestination({
    Key? key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
