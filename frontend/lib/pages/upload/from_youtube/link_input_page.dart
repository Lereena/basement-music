import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LinkInputPage extends StatelessWidget {
  final void Function(String) onFetchPress;
  final void Function() onCancel;
  final String? url;

  LinkInputPage({
    super.key,
    required this.onFetchPress,
    required this.onCancel,
    this.url,
  });

  late final linkController = TextEditingController(text: url ?? '');
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    focusNode.requestFocus();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          child: Text(
            'Insert YouTube link to extract audio',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          alignment: Alignment.center,
          width: min(70.w, 400),
          child: TextField(
            focusNode: focusNode,
            controller: linkController,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
            onSubmitted: (_) => onFetchPress(linkController.text),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          child: const Text('Extract'),
          onPressed: () => onFetchPress(linkController.text),
        ),
        const SizedBox(height: 8),
        TextButton(onPressed: onCancel, child: const Text('Cancel')),
      ],
    );
  }
}
