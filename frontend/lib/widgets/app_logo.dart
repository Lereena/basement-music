import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Theme.of(context).brightness == Brightness.light
          ? 'assets/audio-waves.png'
          : 'assets/audio-waves-colored.png',
      width: size,
      height: size,
    );
  }
}
