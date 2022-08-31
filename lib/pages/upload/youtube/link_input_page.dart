import 'package:flutter/material.dart';

import '../../../utils/input_field_with.dart';
import '../../../widgets/buttons/styled_button.dart';

class LinkInputPage extends StatelessWidget {
  final Function(String) onFetchPress;

  final linkController = TextEditingController();

  LinkInputPage({
    super.key,
    required this.onFetchPress,
  });

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
          width: inputFieldWidth(context),
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
