import 'package:flutter/material.dart';

import 'styled_input_field.dart';

class LinkInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final Function() onDelete;
  final Function() onAdd;

  const LinkInputField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.onDelete,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StyledInputField(
          controller: controller,
          focusNode: focusNode,
          onSubmitted: onSubmitted,
        ),
        SizedBox(width: 10),
        InkWell(
          child: Icon(Icons.close, size: 30),
          onTap: onDelete,
        ),
      ],
    );
  }
}
