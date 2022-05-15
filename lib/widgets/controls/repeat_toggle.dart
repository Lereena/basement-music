import 'package:basement_music/settings.dart';
import 'package:flutter/material.dart';

class RepeatToggle extends StatefulWidget {
  RepeatToggle({Key? key}) : super(key: key);

  @override
  State<RepeatToggle> createState() => _RepeatToggleState();
}

class _RepeatToggleState extends State<RepeatToggle> {
  bool repeat = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      repeat = await getRepeat();
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await setRepeat(!repeat);
        if (mounted) setState(() => repeat = !repeat);
      },
      child: Icon(
        Icons.repeat,
        color: repeat ? Theme.of(context).primaryColor : Colors.grey,
        size: 30,
      ),
    );
  }
}
