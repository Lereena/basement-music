import 'package:flutter/material.dart';

import '../../routes.dart';

class SideNavigationDrawer extends StatefulWidget {
  final int selected;
  final Function(int) onDestinationSelected;

  SideNavigationDrawer({
    Key? key,
    required this.onDestinationSelected,
    required this.selected,
  }) : super(key: key);

  @override
  State<SideNavigationDrawer> createState() => _SideNavigationDrawerState();
}

class _SideNavigationDrawerState extends State<SideNavigationDrawer> {
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('All tracks'),
            selected: selectedIndex == 0,
            onTap: () {
              setState(() => selectedIndex = 0);
              widget.onDestinationSelected(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.featured_play_list_outlined),
            title: Text('Library'),
            selected: selectedIndex == 1,
            onTap: () {
              setState(() => selectedIndex = 1);
              widget.onDestinationSelected(1);
            },
          ),
          ListTile(
            leading: Icon(Icons.person_pin_sharp),
            title: Text('Artists'),
            selected: selectedIndex == 2,
            onTap: () {
              setState(() => selectedIndex = 2);
              widget.onDestinationSelected(2);
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud_upload_outlined),
            title: Text('Upload'),
            selected: selectedIndex == 3,
            onTap: () {
              setState(() => selectedIndex = 3);
              widget.onDestinationSelected(3);
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.settings, size: 30),
            title: Text('Settings'),
            selected: false,
            onTap: () => Navigator.pushNamed(context, NavigationRoute.settings.name),
          ),
        ],
      ),
    );
  }
}
