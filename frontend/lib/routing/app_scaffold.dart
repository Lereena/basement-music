import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:basement_music/bloc/player_bloc/player_bloc.dart';
import 'package:basement_music/models/track.dart';
import 'package:basement_music/widgets/bottom_player.dart';
import 'package:basement_music/widgets/secondary_body_content.dart';
import 'package:basement_music/widgets/wrappers/connectivity_status_wrapper.dart';
import 'package:basement_music/routing/breakpoints.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final playerBloc = context.watch<PlayerBloc>();
    final hasCurrentTrack = playerBloc.state.currentTrack != Track.empty();

    return LayoutBuilder(builder: (context, constraints) {
      final isLarge = constraints.maxWidth >= kLargeBreakpoint;
      final narrow = isLarge && !hasCurrentTrack;
      final horizontalPadding = narrow ? 100.0 : 10.0;

      final bodyWidget = ConnectivityStatusWrapper(
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

      return Column(
        children: [
          Expanded(
            child: isLarge
                ? Row(
                    children: [
                      Expanded(child: bodyWidget),
                      ClipRect(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          width: hasCurrentTrack ? constraints.maxWidth * 0.35 : 0,
                          child: const Row(
                            children: [
                              VerticalDivider(thickness: 1, width: 1),
                              Expanded(child: SecondaryBodyContent()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : bodyWidget,
          ),
          if (!isLarge) const SelectionArea(child: BottomPlayer()),
        ],
      );
    });
  }
}
