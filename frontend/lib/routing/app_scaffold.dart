import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/player_bloc/player_bloc.dart';
import '../models/track.dart';
import '../widgets/bottom_player.dart';
import '../widgets/secondary_body_content.dart';
import '../widgets/wrappers/connectivity_status_wrapper.dart';

const _largeBreakpoint = WidthPlatformBreakpoint(begin: 1000);
const _mediumBreakpoint = WidthPlatformBreakpoint(begin: 600, end: 1000);

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({
    Key? key,
    required this.child,
  }) : super(key: key ?? const Key('AppScaffold'));

  @override
  Widget build(BuildContext context) {
    final playerBloc = context.watch<PlayerBloc>();
    final hasCurrentTrack = playerBloc.currentTrack != Track.empty();

    return AdaptiveLayout(
      bodyRatio: 0.65,
      body: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          Breakpoints.small: _body(narrow: false, drawerNavigation: true),
          _mediumBreakpoint: _body(narrow: false),
          _largeBreakpoint: _body(narrow: !hasCurrentTrack),
        },
      ),
      secondaryBody: SlotLayout(
        config: <Breakpoint, SlotLayoutConfig>{
          if (hasCurrentTrack)
            _largeBreakpoint: SlotLayout.from(
              inAnimation: AdaptiveScaffold.fadeIn,
              key: const Key('secondaryBody'),
              builder: (_) => const SecondaryBodyContent(),
            ),
        },
      ),
      bottomNavigation: SlotLayout(
        config: {
          _mediumBreakpoint: _bottomBar,
          Breakpoints.small: _bottomBar,
        },
      ),
    );
  }

  SlotLayoutConfig _body({
    required bool narrow,
    bool drawerNavigation = false,
  }) =>
      SlotLayout.from(
        inAnimation: AdaptiveScaffold.stayOnScreen,
        key: const Key('body'),
        builder: (context) {
          final horizontalPadding = narrow ? 100.0 : 10.0;
          return ConnectivityStatusWrapper(
            child: SelectionArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  top: 10,
                ),
                child: child,
              ),
            ),
          );
        },
      );

  SlotLayoutConfig get _bottomBar => SlotLayout.from(
        inAnimation: AdaptiveScaffold.bottomToTop,
        key: const Key('bottom'),
        builder: (_) => SelectionArea(child: BottomPlayer()),
      );
}
