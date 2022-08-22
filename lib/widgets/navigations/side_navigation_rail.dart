import 'package:flutter/material.dart';

import '../settings/settings_button.dart';

class SideNavigationRail extends StatefulWidget {
  final Function(int) onDestinationSelected;

  const SideNavigationRail({Key? key, required this.onDestinationSelected}) : super(key: key);

  @override
  State<SideNavigationRail> createState() => _SideNavigationRailState();
}

class _SideNavigationRailState extends State<SideNavigationRail> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.onDestinationSelected(index);
      },
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.favorite),
          label: Text('All tracks'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.featured_play_list_outlined),
          label: Text('Library'),
        ),
        // NavigationRailDestination(
        //   icon: Icon(Icons.person_pin_sharp),
        //   label: Text('Artists'),
        // ),
      ],
      trailing: const SettingsButton(),
    );
  }
}
