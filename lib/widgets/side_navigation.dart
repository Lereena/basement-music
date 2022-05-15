import 'package:flutter/material.dart';

class SideNavigation extends StatefulWidget {
  SideNavigation({Key? key}) : super(key: key);

  @override
  State<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => setState(() => selectedIndex = index),
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.favorite),
          label: Text('Favourites'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.featured_play_list_outlined),
          label: Text('Library'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_pin_sharp),
          label: Text('Artists'),
        ),
      ],
    );
  }
}
