import 'package:flutter/material.dart';

import 'rail_theme.dart';

class SideNavigationDestination extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool selected;
  final Function() onTap;

  const SideNavigationDestination({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final navigationRailTheme = NavigationRailDefaultsM2(context);

    final unselectedLabelTextStyle = navigationRailTheme.unselectedLabelTextStyle!;
    final selectedLabelTextStyle = navigationRailTheme.selectedLabelTextStyle!;
    final unselectedIconTheme = navigationRailTheme.unselectedIconTheme!;
    final selectedIconTheme = navigationRailTheme.selectedIconTheme!;

    return TextButton(
      onPressed: onTap,
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            children: [
              IconTheme(
                data: selected ? selectedIconTheme : unselectedIconTheme,
                child: icon,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: selected ? selectedLabelTextStyle : unselectedLabelTextStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
