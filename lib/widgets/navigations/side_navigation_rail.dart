import 'package:flutter/material.dart';

import '../../enums/pages_enum.dart';
import '../settings/settings_button.dart';

class SideNavigationRail extends StatelessWidget {
  final PageNavigation selectedPage;
  final Function(int) onDestinationSelected;

  const SideNavigationRail({
    Key? key,
    required this.selectedPage,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: PageNavigation.values.indexWhere((element) => element == selectedPage),
      onDestinationSelected: onDestinationSelected,
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
