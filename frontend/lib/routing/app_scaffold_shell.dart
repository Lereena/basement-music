import 'package:basement_music/routing/app_scaffold.dart';
import 'package:basement_music/routing/breakpoints.dart';
import 'package:basement_music/widgets/leading_rail_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  const AppScaffoldShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < kSmallBreakpoint;
        final isLarge = constraints.maxWidth >= kLargeBreakpoint;
        final body = AppScaffold(child: navigationShell);

        if (isSmall) {
          return Scaffold(
            body: body,
            bottomNavigationBar: _NavigationBottomBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (i) => onNavigationEvent(context, i),
            ),
          );
        }

        return Scaffold(
          body: Row(
            children: [
              _NavigationSidebar(
                extended: isLarge,
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (i) => onNavigationEvent(context, i),
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: body),
            ],
          ),
        );
      },
    );
  }

  void onNavigationEvent(BuildContext context, int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }
}

class _NavigationSidebar extends StatelessWidget {
  final bool extended;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _NavigationSidebar({required this.extended, required this.selectedIndex, required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: extended ? 256.0 : 80.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(child: LeadingRailWidget(extended: extended)),
          ),
          ..._Destination.values.indexed.map((entry) {
            final (i, dest) = entry;
            final selected = i == selectedIndex;
            final iconColor = selected
                ? theme.primaryColor.withValues(alpha: 0.8)
                : theme.colorScheme.onSurface.withValues(alpha: 0.64);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  hoverColor: theme.primaryColor.withValues(alpha: 0.1),
                  highlightColor: theme.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => onDestinationSelected(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: extended
                        ? Row(
                            children: [
                              IconTheme.merge(
                                data: IconThemeData(color: iconColor),
                                child: dest.icon,
                              ),
                              const SizedBox(width: 12),
                              Text(dest.title, style: TextStyle(color: iconColor)),
                            ],
                          )
                        : Tooltip(
                            message: dest.title,
                            child: Center(
                              child: IconTheme.merge(
                                data: IconThemeData(color: iconColor),
                                child: dest.icon,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _NavigationBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _NavigationBottomBar({required this.selectedIndex, required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: Colors.transparent,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) return theme.primaryColor.withValues(alpha: 0.1);
          if (states.contains(WidgetState.pressed)) return theme.primaryColor.withValues(alpha: 0.2);
          return null;
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? theme.primaryColor.withValues(alpha: 0.9)
              : theme.colorScheme.onSurface;
          return IconThemeData(color: color);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? theme.primaryColor.withValues(alpha: 0.9)
              : theme.colorScheme.onSurface;
          return TextStyle(color: color);
        }),
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: _Destination.values.map((e) => NavigationDestination(icon: e.icon, label: e.title)).toList(),
      ),
    );
  }
}
