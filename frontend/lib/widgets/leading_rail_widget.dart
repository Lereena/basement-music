import 'package:flutter/material.dart';

import 'app_logo.dart';

class LeadingRailWidget extends StatelessWidget {
  final bool extended;

  const LeadingRailWidget({super.key, required this.extended});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: extended ? 100 : 50,
          child: const AppLogo(),
        ),
        const Divider(indent: 10, endIndent: 10),
      ],
    );
  }
}
