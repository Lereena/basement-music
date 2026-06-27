import 'package:flutter/material.dart';

class ScrollablePlaceholder extends StatelessWidget {
  final Widget child;

  const ScrollablePlaceholder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: child),
        ),
      ],
    );
  }
}
