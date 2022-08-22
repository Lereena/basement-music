import 'package:flutter/material.dart';

import '../../routes.dart';

class SideNavigationDrawer extends StatefulWidget {
  final int selected;
  final Function(int) onDestinationSelected;

  const SideNavigationDrawer({
    Key? key,
    required this.onDestinationSelected,
    required this.selected,
  }) : super(key: key);

  @override
  State<SideNavigationDrawer> createState() => _SideNavigationDrawerState();
}

class _SideNavigationDrawerState extends State<SideNavigationDrawer> {
  var _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('All tracks'),
            selected: _selectedIndex == 0,
            onTap: () {
              setState(() => _selectedIndex = 0);
              widget.onDestinationSelected(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.featured_play_list_outlined),
            title: const Text('Library'),
            selected: _selectedIndex == 1,
            onTap: () {
              setState(() => _selectedIndex = 1);
              widget.onDestinationSelected(1);
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.person_pin_sharp),
          //   title: Text('Artists'),
          //   selected: selectedIndex == 2,
          //   onTap: () {
          //     setState(() => selectedIndex = 2);
          //     widget.onDestinationSelected(2);
          //   },
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
