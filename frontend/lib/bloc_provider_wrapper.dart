import 'package:flutter/material.dart';

import 'app_config.dart';
import 'shortcuts_wrapper.dart';

class BlocProviderWrapper extends StatefulWidget {
  final Widget child;
  final AppConfig appConfig;

  const BlocProviderWrapper({
    super.key,
    required this.appConfig,
    required this.child,
  });

  @override
  State<BlocProviderWrapper> createState() => _BlocProviderWrapperState();
}

class _BlocProviderWrapperState extends State<BlocProviderWrapper> {
  @override
  Widget build(BuildContext context) {
    return ShortcutsWrapper(
      child: widget.child,
    );
  }
}
