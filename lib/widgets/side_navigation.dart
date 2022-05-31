import 'package:flutter/material.dart';

class SideNavigation extends StatefulWidget {
  final Function(int) onDestinationSelected;
  SideNavigation({Key? key, required this.onDestinationSelected}) : super(key: key);

  @override
  State<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          selectedIndex = index;
        });
        widget.onDestinationSelected(index);
      },
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
        NavigationRailDestination(
          icon: Icon(Icons.cloud_upload_outlined),
          label: Text('Upload'),
        ),
      ],
    );
  }
}
