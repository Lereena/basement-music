import 'package:flutter/material.dart';

class TitledField extends StatelessWidget {
  final String title;
  final double fieldWidth;
  final TextEditingController controller;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;

  const TitledField({
    Key? key,
    required this.title,
    required this.fieldWidth,
    required this.controller,
    this.onSubmitted,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: fieldWidth,
          child: TextField(
            controller: controller,
            onSubmitted: onSubmitted,
            focusNode: focusNode,
          ),
        ),
      ],
    );
  }
}
