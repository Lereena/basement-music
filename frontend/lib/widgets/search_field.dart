import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final void Function(String) onSearch;
  final TextEditingController controller;
  final FocusNode focusNode;

  const SearchField({
    super.key,
    required this.onSearch,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      textAlign: TextAlign.left,
      textInputAction: TextInputAction.search,
      style: Theme.of(context).textTheme.titleLarge,
      onSubmitted: (text) => onSearch(text),
      decoration: InputDecoration(
        suffixIcon: InkWell(
          hoverColor: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            focusNode.unfocus();
            onSearch(controller.text);
          },
          child: const Icon(Icons.search, size: 30),
        ),
      ),
    );
  }
}
