import 'package:flutter/material.dart';

import '../../utils/input_field_with.dart';

class StyledInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSubmitted;

  const StyledInputField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        constraints: BoxConstraints(maxWidth: inputFieldWidth(context)),
        isDense: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      focusNode: focusNode,
      maxLines: 1,
      controller: controller,
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.headline6,
      onSubmitted: onSubmitted,
    );
  }
}
