import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/leading_rail_widget.dart';
import 'app_scaffold.dart';
import 'breakpoints.dart';

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
    return LayoutBuilder(builder: (context, constraints) {
      final isSmall = constraints.maxWidth < kSmallBreakpoint;
      final isLarge = constraints.maxWidth >= kLargeBreakpoint;
      final body = AppScaffold(child: navigationShell);

      if (isSmall) {
        return Scaffold(
          body: body,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (i) => onNavigationEvent(context, i),
            destinations: _Destination.values
                .map((e) => NavigationDestination(icon: e.icon, label: e.title))
                .toList(),
          ),
        );
      }

      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: isLarge,
              leading: LeadingRailWidget(extended: isLarge),
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (i) => onNavigationEvent(context, i),
              destinations: _Destination.values
                  .map((e) => NavigationRailDestination(
                        icon: e.icon,
                        label: Text(e.title),
                      ))
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: body),
          ],
        ),
      );
    });
  }

  void onNavigationEvent(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
