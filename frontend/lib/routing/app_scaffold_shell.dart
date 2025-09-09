import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';

import '../widgets/leading_rail_widget.dart';
import 'app_scaffold.dart';

enum _Destination {
  tracks,
  library,
  search,
  upload,
  settings;

  String get title => switch (this) {
        tracks => 'All tracks',
        library => 'Library',
        search => 'Search',
        settings => 'Settings',
        upload => 'Upload',
      };

  Widget get icon => switch (this) {
        tracks => const Icon(Icons.home),
        library => const Icon(Icons.library_music),
        search => const Icon(Icons.search),
        settings => const Icon(Icons.settings),
        upload => const Icon(Icons.upload),
      };
}

class AppScaffoldShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffoldShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      useDrawer: false,
      drawerBreakpoint: Breakpoints.small,
      leadingExtendedNavRail: const LeadingRailWidget(extended: true),
      leadingUnextendedNavRail: const LeadingRailWidget(extended: false),
      selectedIndex: navigationShell.currentIndex,
      onSelectedIndexChange: (index) => onNavigationEvent(context, index),
      destinations: _Destination.values
          .map(
            (e) => NavigationDestination(
              icon: e.icon,
              label: e.title,
            ),
          )
          .toList(),
      body: (_) => AppScaffold(child: navigationShell),
    );
  }

  void onNavigationEvent(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
