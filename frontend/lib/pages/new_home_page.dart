import 'package:basement_music/widgets/secondary_body_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/side_navigation_bloc/side_navigation_cubit.dart';
import '../widgets/main_body_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sideNavigationCubit = BlocProvider.of<SideNavigationCubit>(context);

    return BlocBuilder<SideNavigationCubit, SideNavigationState>(
      builder: (context, state) {
        return AdaptiveScaffold(
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.library_music),
              label: 'Library',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          bodyRatio: 0.6,
          onSelectedIndexChange: (index) => sideNavigationCubit.selectDestination(index),
          body: (_) => MainBodyContent(selectedPage: state.selectedPage),
          smallBody: (_) => MainBodyContent(selectedPage: state.selectedPage),
          secondaryBody: (_) => const SecondaryBodyContent(),
          smallSecondaryBody: AdaptiveScaffold.emptyBuilder,
          smallBreakpoint: const WidthPlatformBreakpoint(end: 700),
          mediumBreakpoint: const WidthPlatformBreakpoint(begin: 700, end: 1000),
          largeBreakpoint: const WidthPlatformBreakpoint(begin: 1000),
          leadingExtendedNavRail: SizedBox(
            height: 100,
            child: Icon(
              Icons.music_note,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          leadingUnextendedNavRail: SizedBox(
            height: 100,
            child: Icon(
              Icons.music_note,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
    );
  }
}
