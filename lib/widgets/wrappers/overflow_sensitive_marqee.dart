import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class OverflowSensitiveMarquee extends StatelessWidget {
  const OverflowSensitiveMarquee(
    this.text, {
    Key? key,
    required this.style,
    this.velocity = 10,
    this.blankSpace = 20,
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final double velocity;
  final double blankSpace;

  @override
  Widget build(BuildContext context) {
    final fontSize = style.fontSize ?? 18;
    return SizedBox(
      child: AutoSizeText(
        text,
        minFontSize: fontSize,
        maxFontSize: fontSize,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: style.fontWeight,
        ),
        overflowReplacement: Marquee(
          text: text,
          blankSpace: blankSpace,
          showFadingOnlyWhenScrolling: false,
          accelerationCurve: Curves.easeOutCubic,
          velocity: velocity,
          startPadding: 2.0,
          style: style,
        ),
      ),
    );
  }
}
