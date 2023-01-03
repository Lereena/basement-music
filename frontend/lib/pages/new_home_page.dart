import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

import '../widgets/bottom_player.dart';
import '../widgets/main_body_content.dart';
import '../widgets/navigations/web_navigation/side_navigation_rail.dart';
import '../widgets/secondary_body_content.dart';

const largeBreakpoint = WidthPlatformBreakpoint(begin: 1000);
const mediumBreakpoint = WidthPlatformBreakpoint(begin: 600, end: 1000);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
          Breakpoints.standard: _body,
        },
      ),
      secondaryBody: SlotLayout(
        config: {
          largeBreakpoint: SlotLayout.from(
            inAnimation: AdaptiveScaffold.fadeIn,
            key: const Key('Secondary body large'),
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

  SlotLayoutConfig get _body => SlotLayout.from(
        inAnimation: AdaptiveScaffold.stayOnScreen,
        key: const Key('body'),
        builder: (_) => const MainBodyContent(),
      );

  SlotLayoutConfig get _bottomBar => SlotLayout.from(
        inAnimation: AdaptiveScaffold.bottomToTop,
        key: const Key('bottom bar'),
        builder: (_) => BottomPlayer(),
      );
}
