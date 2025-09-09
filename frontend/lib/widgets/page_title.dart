import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String text;

  const PageTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: theme.primaryColor,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(
          text,
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: 18,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}
