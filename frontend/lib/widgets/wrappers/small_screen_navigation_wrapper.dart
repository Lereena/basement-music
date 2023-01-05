import 'package:flutter/material.dart';

import '../navigations/side_navigation_drawer.dart';
import '../page_title.dart';

class SmallScreenNavigationWrapper extends StatelessWidget {
  final Widget child;

  const SmallScreenNavigationWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        scrolledUnderElevation: 1,
        iconTheme: Theme.of(context).iconTheme,
        title: const PageTitle(text: 'All tracks'),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      drawer: const SideNavigationDrawer(),
      body: child,
    );
  }
}
