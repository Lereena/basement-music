import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/buttons/styled_button.dart';

class LinkInputPage extends StatelessWidget {
  final void Function(String) onFetchPress;
  final String? url;

  LinkInputPage({
    super.key,
    required this.onFetchPress,
    this.url,
  });

  late final linkController = TextEditingController(text: url ?? '');
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    focusNode.requestFocus();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          child: Text(
            'Insert YouTube link to extract audio',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: min(70.w, 400),
          child: TextField(
            focusNode: focusNode,
            controller: linkController,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
            onSubmitted: (_) => onFetchPress(linkController.text),
          ),
        ),
        const SizedBox(height: 40),
        StyledButton(
          title: 'Extract',
          onPressed: () => onFetchPress(linkController.text),
        ),
      ],
    );
  }
}
