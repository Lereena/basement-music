import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final bool autofocus;
  final FocusNode? focusNode;

  const StyledButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton(
        focusNode: focusNode,
        autofocus: autofocus,
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(title, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
