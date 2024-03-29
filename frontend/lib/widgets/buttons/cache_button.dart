import 'package:flutter/material.dart';

class CacheButton extends StatelessWidget {
  final Function() onCache;

  const CacheButton({super.key, required this.onCache});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCache,
      child: const Icon(Icons.download_outlined),
    );
  }
}
