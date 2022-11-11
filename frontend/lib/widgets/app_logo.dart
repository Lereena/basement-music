import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Theme.of(context).brightness == Brightness.light ? 'assets/audio-waves.png' : 'assets/audio-waves-colored.png',
      width: 40,
      height: 40,
    );
  }
}
