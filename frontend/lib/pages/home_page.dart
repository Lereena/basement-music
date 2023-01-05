import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/player_bloc/player_bloc.dart';
import '../models/track.dart';
import '../widgets/bottom_player.dart';
import '../widgets/main_body_content.dart';
import '../widgets/navigations/side_navigation_rail.dart';
import '../widgets/secondary_body_content.dart';

const largeBreakpoint = WidthPlatformBreakpoint(begin: 1000);
const mediumBreakpoint = WidthPlatformBreakpoint(begin: 600, end: 1000);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final playerBloc = context.watch<PlayerBloc>();
    final hasCurrentTrack = playerBloc.currentTrack != Track.empty();

    return AdaptiveLayout(
      bodyRatio: 0.65,
      primaryNavigation: SlotLayout(
        config: {
          largeBreakpoint: _navigationRail(extended: true),
          mediumBreakpoint: _navigationRail(extended: false),
        },
      ),
      body: SlotLayout(
        config: {
          largeBreakpoint: _body(narrow: !hasCurrentTrack),
          mediumBreakpoint: _body(narrow: false),
          Breakpoints.small: _body(narrow: false, drawerNavigation: true),
        },
      ),
      secondaryBody: SlotLayout(
        config: {
          if (hasCurrentTrack)
            largeBreakpoint: SlotLayout.from(
              inAnimation: AdaptiveScaffold.fadeIn,
              key: const Key('secondary body'),
              builder: (_) => const SecondaryBodyContent(),
            ),
        },
      ),
      bottomNavigation: SlotLayout(
        config: {
          mediumBreakpoint: _bottomBar,
          Breakpoints.small: _bottomBar,
        },
      ),
    );
  }

  SlotLayoutConfig _navigationRail({required bool extended}) => SlotLayout.from(
        key: Key('navigation $extended'),
        inAnimation: AdaptiveScaffold.fadeIn,
        builder: (_) => SideNavigationRail(extended: extended),
      );

  SlotLayoutConfig _body({required bool narrow, bool drawerNavigation = false}) => SlotLayout.from(
        inAnimation: AdaptiveScaffold.stayOnScreen,
        key: const Key('body'),
        builder: (context) => MainBodyContent(
          narrow: narrow,
          drawerNavigation: drawerNavigation,
        ),
      );

  SlotLayoutConfig get _bottomBar => SlotLayout.from(
        inAnimation: AdaptiveScaffold.bottomToTop,
        key: const Key('bottom'),
        builder: (_) => BottomPlayer(),
      );
}
