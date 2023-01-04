import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ContentNarrower extends StatelessWidget {
  final Widget child;
  final bool enable;

  const ContentNarrower({
    super.key,
    required this.child,
    this.enable = false,
  });

  @override
  Widget build(BuildContext context) {
    return kIsWeb && enable
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: child,
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: child,
          );
  }
}
