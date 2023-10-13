import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';

import '../widgets/leading_rail_widget.dart';
import 'app_scaffold.dart';
import 'routes.dart';

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
      destinations: [
        NavigationRoute.tracks,
        NavigationRoute.library,
        NavigationRoute.search,
        NavigationRoute.upload,
        NavigationRoute.settings,
      ]
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
