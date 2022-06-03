import 'package:basement_music/settings.dart';
import 'package:flutter/material.dart';

class ShuffleToggle extends StatefulWidget {
  ShuffleToggle({Key? key}) : super(key: key);

  @override
  State<ShuffleToggle> createState() => _ShuffleToggleState();
}

class _ShuffleToggleState extends State<ShuffleToggle> {
  bool shuffle = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      shuffle = await getShuffle();
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await setShuffle(!shuffle);
        if (mounted) setState(() => shuffle = !shuffle);
      },
      child: Icon(
        shuffle ? Icons.shuffle_on_outlined : Icons.shuffle,
        color: Theme.of(context).primaryColor,
        size: 30,
      ),
    );
  }
}
