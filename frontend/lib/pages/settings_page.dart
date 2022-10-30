import 'package:basement_music/widgets/settings/theme_setting_line.dart';
import 'package:basement_music/widgets/wrappers/content_narrower.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          height: 100,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: DecoratedBox(
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        ContentNarrower(
          child: Column(
            children: const [
              SizedBox(height: 8),
              ThemeSettingLine(),
            ],
          ),
        ),
      ],
    );
  }
}
