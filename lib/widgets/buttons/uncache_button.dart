import 'package:flutter/material.dart';

class UncacheButton extends StatelessWidget {
  final Function() onUncache;

  const UncacheButton({Key? key, required this.onUncache}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(Icons.file_download_off_rounded),
      onTap: onUncache,
    );
  }
}
