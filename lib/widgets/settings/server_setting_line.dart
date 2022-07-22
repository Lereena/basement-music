import 'package:flutter/material.dart';

import '../../api.dart';
import 'settings_line_decoration.dart';

class ServerSettingLine extends StatefulWidget {
  const ServerSettingLine({Key? key}) : super(key: key);

  @override
  State<ServerSettingLine> createState() => _ServerSettingLineState();
}

class _ServerSettingLineState extends State<ServerSettingLine> {
  final controller = TextEditingController(text: host);

  @override
  Widget build(BuildContext context) {
    return SettingsLineDecoration(
      child: InkWell(
        child: Container(
          height: 40,
          child: Row(
            children: [
              Text('Server host'),
              Spacer(),
              Text('$host'),
            ],
          ),
        ),
        onTap: () => showDialog(
          context: context,
          builder: (context) => Dialog(
              child: TextField(
            controller: controller,
            onEditingComplete: () {
              setState(() {
                host = controller.text;
              });
            },
          )),
        ),
      ),
    );
  }
}
