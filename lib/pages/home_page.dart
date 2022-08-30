import 'package:basement_music/bloc/side_navigation_bloc/side_navigation_cubit.dart';
import 'package:basement_music/widgets/navigations/side_navigation_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../enums/pages_enum.dart';
import '../routes.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/create_playlist.dart';
import '../widgets/dialog.dart';
import '../widgets/main_content.dart';
import '../widgets/navigations/side_navigation_drawer.dart';

const pagesWithFAB = [PageNavigation.allTracks, PageNavigation.library];

class MyHomePage extends StatelessWidget {
  final sideNavigationCubit = SideNavigationCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sideNavigationCubit,
      child: BlocBuilder<SideNavigationCubit, SideNavigationState>(
        builder: (context, state) {
          return Scaffold(
            body: kIsWeb
                ? Row(
                    children: [
                      const SideNavigationWeb(),
                      // SideNavigationRail(
                      //   selectedPage: state.selectedPage,
                      //   onDestinationSelected: (index) {
                      //     sideNavigationCubit.selectDestination(index);
                      //   },
                      // ),
                      const VerticalDivider(width: 1),
                      MainContent(selectedPage: state.selectedPage),
                    ],
                  )
                : Column(
                    children: [
                      MainContent(selectedPage: state.selectedPage),
                    ],
                  ),
            drawer: kIsWeb
                ? null
                : SideNavigationDrawer(
                    selectedPage: state.selectedPage,
                    onDestinationSelected: (index) {
                      sideNavigationCubit.selectDestination(index);
                      Navigator.pop(context);
                    },
                  ),
            bottomNavigationBar: BottomBar(),
            floatingActionButton: pagesWithFAB.contains(state.selectedPage)
                ? FloatingActionButton(
                    onPressed: () => _fabActionByPage(context, state.selectedPage)(),
                    child: const Icon(Icons.add),
                  )
                : null,
          );
        },
      ),
    );
  }

  Function _fabActionByPage(BuildContext context, PageNavigation page) {
    switch (page) {
      case PageNavigation.allTracks:
        return () => Navigator.pushNamed(context, NavigationRoute.upload.name);
      case PageNavigation.library:
        return () => showDialog(
              context: context,
              builder: (context) => const CustomDialog(child: CreatePlaylist()),
            );
      default:
        throw Exception('No action for $page');
    }
  }
}
