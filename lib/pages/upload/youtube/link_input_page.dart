import 'dart:math';

import 'package:flutter/material.dart';

import '../../../widgets/buttons/styled_button.dart';

class LinkInputPage extends StatelessWidget {
  final TextEditingController linkController;
  final Function() onFetchPress;

  LinkInputPage({
    Key? key,
    required this.linkController,
    required this.onFetchPress,
  }) : super(key: key);

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final inputFieldWidth = min(MediaQuery.of(context).size.width / 1.5, 400).toDouble();
    focusNode.requestFocus();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Insert YouTube link to extract audio',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: inputFieldWidth,
          child: TextField(
            focusNode: focusNode,
            controller: linkController,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
            onSubmitted: (_) => onFetchPress(),
          ),
        ),
        SizedBox(height: 40),
        StyledButton(
          title: 'Extract',
          onPressed: onFetchPress,
        ),
      ],
    );
  }
}
