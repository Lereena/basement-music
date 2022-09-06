import 'package:basement_music/bloc/side_navigation_bloc/side_navigation_cubit.dart';
import 'package:basement_music/widgets/navigations/web_navigation/side_navigation_rail.dart';
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

const pagesWithFAB = [PageNavigation.home, PageNavigation.library];

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sideNavigationCubit = BlocProvider.of<SideNavigationCubit>(context);

    return BlocBuilder<SideNavigationCubit, SideNavigationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: kIsWeb ? null : AppBar(),
          body: kIsWeb
              ? Row(
                  children: [
                    SideNavigationRail(
                      selectedPage: state.selectedPage,
                      onDestinationSelected: (index) {
                        sideNavigationCubit.selectDestination(index);
                      },
                    ),
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
    );
  }

  Function _fabActionByPage(BuildContext context, PageNavigation page) {
    switch (page) {
      case PageNavigation.home:
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
