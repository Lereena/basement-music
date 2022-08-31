import 'package:flutter/material.dart';

class SettingsLineDecoration extends StatelessWidget {
  final Widget child;

  const SettingsLineDecoration({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: child,
        ),
        const Divider(),
      ],
    );
  }
}
