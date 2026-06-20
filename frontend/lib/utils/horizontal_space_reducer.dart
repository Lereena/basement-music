import 'package:basement_music/routing/breakpoints.dart';
import 'package:flutter/material.dart';

class HorizontalSpaceReducer extends StatelessWidget {
  final Widget child;

  const HorizontalSpaceReducer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLarge = constraints.maxWidth >= kLargeBreakpoint;
        final padding = isLarge ? 100.0 : 12.0;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: child,
        );
      },
    );
  }
}
