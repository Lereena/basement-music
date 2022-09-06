import 'package:flutter/material.dart';

class UnderlinedButton extends StatelessWidget {
  final Function() onPressed;
  final bool underlined;
  final String text;

  const UnderlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.underlined,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: underlined
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          : const BoxDecoration(),
      child: TextButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
