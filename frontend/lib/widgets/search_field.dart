import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final void Function(String) onSearch;
  final bool autofocus;

  SearchField({
    super.key,
    required this.onSearch,
    required this.autofocus,
  });

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: autofocus,
      textAlign: TextAlign.left,
      textInputAction: TextInputAction.search,
      style: Theme.of(context).textTheme.titleLarge,
      onSubmitted: (text) => onSearch(text),
      decoration: InputDecoration(
        suffixIcon: InkWell(
          hoverColor: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            onSearch(_controller.text);
          },
          child: const Icon(Icons.search, size: 30),
        ),
      ),
    );
  }
}
