import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/navigation_cubit/navigation_cubit.dart';
import '../app_logo.dart';
import 'rail_theme.dart';

class SideNavigationRail extends StatefulWidget {
  final bool extended;

  const SideNavigationRail({super.key, required this.extended});

  @override
  State<SideNavigationRail> createState() => _SideNavigationRailState();
}

class _SideNavigationRailState extends State<SideNavigationRail> {
  late final _navigationCubit = BlocProvider.of<NavigationCubit>(context);
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final navigationRailTheme = NavigationRailDefaultsM2(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AdaptiveScaffold.standardNavigationRail(
          extended: widget.extended,
          unselectedIconTheme: navigationRailTheme.unselectedIconTheme,
          selectedIconTheme: navigationRailTheme.selectedIconTheme,
          selectedLabelTextStyle: navigationRailTheme.selectedLabelTextStyle,
          leading: Column(
            children: [
              SizedBox(
                height: widget.extended ? 100 : 50,
                child: const AppLogo(),
              ),
              const Divider(indent: 10, endIndent: 10),
            ],
          ),
          selectedIndex: _selectedIndex,
          destinations: _destinations,
          onDestinationSelected: _navigate,
        ),
        const VerticalDivider(width: 1),
      ],
    );
  }

  final _destinations = const [
    NavigationRailDestination(
      icon: Icon(Icons.home),
      label: Text('Home'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.library_music),
      label: Text('Library'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.search),
      label: Text('Search'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.upload),
      label: Text('Upload track'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.settings),
      label: Text('Settings'),
    ),
  ];

  late final _navigateCallbacks = [
    _navigationCubit.navigateHome,
    _navigationCubit.navigateLibrary,
    _navigationCubit.navigateSearch,
    _navigationCubit.navigateUploadTrack,
    _navigationCubit.navigateSettings,
  ];

  void _navigate(int index) {
    _navigateCallbacks[index]();
    setState(() => _selectedIndex = index);
  }
}
