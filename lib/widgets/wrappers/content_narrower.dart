import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ContentNarrower extends StatelessWidget {
  final Widget child;

  const ContentNarrower({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: child,
          )
        : child;
  }
}
