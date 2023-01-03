import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/side_navigation_bloc/side_navigation_cubit.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/main_body_content.dart';
import '../widgets/navigations/side_navigation_drawer.dart';
import '../widgets/navigations/web_navigation/side_navigation_rail.dart';

class HomePage extends StatelessWidget {
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
                    const SideNavigationRail(extended: true),
                    const VerticalDivider(width: 1),
                    MainBodyContent(selectedPage: state.selectedPage),
                  ],
                )
              : Column(
                  children: [
                    MainBodyContent(selectedPage: state.selectedPage),
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
        );
      },
    );
  }
}
