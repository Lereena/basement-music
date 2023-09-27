import 'package:flutter/material.dart';

import '../page_title.dart';
import 'side_navigation_drawer.dart';

class DrawerNavigationWrapper extends StatelessWidget {
  final bool drawerNavigation;
  final String pageTitle;
  final Widget child;

  const DrawerNavigationWrapper({
    super.key,
    required this.drawerNavigation,
    required this.pageTitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        scrolledUnderElevation: theme.brightness == Brightness.dark ? 0 : 1,
        iconTheme: theme.iconTheme,
        title: PageTitle(text: pageTitle),
        leading: drawerNavigation
            ? Builder(
                builder: (context) => InkWell(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  customBorder: const CircleBorder(),
                  child: const Icon(Icons.menu),
                ),
              )
            : null,
        backgroundColor: theme.colorScheme.background,
      ),
      drawer: drawerNavigation ? const SideNavigationDrawer() : null,
      body: child,
    );
  }
}
