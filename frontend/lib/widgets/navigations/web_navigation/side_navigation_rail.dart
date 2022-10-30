import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/navigation_cubit/navigation_cubit.dart';
import 'navigation_destination.dart';
import 'rail_theme.dart';

class SideNavigationRail extends StatelessWidget {
  const SideNavigationRail({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationCubit = BlocProvider.of<NavigationCubit>(context);

    final navigationRailTheme = NavigationRailDefaultsM2(context);

    final backgroundColor = navigationRailTheme.backgroundColor!;
    final elevation = navigationRailTheme.elevation!;

    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Material(
          color: backgroundColor,
          elevation: elevation,
          child: SizedBox(
            width: 300,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Icon(
                    Icons.music_note,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Divider(indent: 10, endIndent: 10),
                SideNavigationDestination(
                  icon: const Icon(Icons.home),
                  label: 'Home',
                  selected: state is NavigationHome,
                  onTap: () => navigationCubit.navigateHome(),
                ),
                SideNavigationDestination(
                  icon: const Icon(Icons.library_music),
                  label: 'Library',
                  selected: state is NavigationLibrary,
                  onTap: () => navigationCubit.navigateLibrary(),
                ),
                SideNavigationDestination(
                  icon: const Icon(Icons.groups),
                  label: 'Artists',
                  selected: state is NavigationArtistsList,
                  onTap: () => navigationCubit.navigateArtistsList(),
                ),
                SideNavigationDestination(
                  icon: const Icon(Icons.upload),
                  label: 'Upload track',
                  selected: state is NavigationUploadTrack,
                  onTap: () => navigationCubit.navigateUploadTrack(),
                ),
                const Spacer(),
                const Divider(indent: 10, endIndent: 10),
                SideNavigationDestination(
                  icon: const Icon(Icons.settings),
                  label: 'Settings',
                  selected: state is NavigationSettings,
                  onTap: () => navigationCubit.navigateSettings(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
