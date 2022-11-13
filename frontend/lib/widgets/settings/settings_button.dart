import 'package:flutter/material.dart';

import '../../routes.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(bottom: 15),
        alignment: Alignment.bottomCenter,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          child: const SizedBox(
            width: 50,
            height: 50,
            child: Icon(Icons.settings, size: 30),
          ),
          onTap: () => Navigator.pushNamed(context, NavigationRoute.settings.name),
        ),
      ),
    );
  }
}
