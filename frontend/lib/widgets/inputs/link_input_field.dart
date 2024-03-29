import 'package:flutter/material.dart';

import 'styled_input_field.dart';

class LinkInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final Function() onDelete;
  final Function() onAdd;

  const LinkInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StyledInputField(
          controller: controller,
          focusNode: focusNode,
          onSubmitted: onSubmitted,
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onDelete,
          child: const Icon(Icons.close, size: 30),
        ),
      ],
    );
  }
}
