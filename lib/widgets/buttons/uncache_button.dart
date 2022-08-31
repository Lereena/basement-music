import 'package:flutter/material.dart';

class UncacheButton extends StatelessWidget {
  final Function() onUncache;

  const UncacheButton({super.key, required this.onUncache});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onUncache,
      child: const Icon(Icons.file_download_off_rounded),
    );
  }
}
