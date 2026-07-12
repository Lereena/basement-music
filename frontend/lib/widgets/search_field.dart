import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final void Function(String) onSearch;
  final bool autofocus;
  final Widget? leading;
  final String? hint;

  const SearchField({
    super.key,
    required this.onSearch,
    required this.autofocus,
    this.leading,
    this.hint,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      textAlign: TextAlign.left,
      textInputAction: TextInputAction.search,
      style: Theme.of(context).textTheme.titleLarge,
      onSubmitted: (text) => widget.onSearch(text),
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: widget.leading,
        suffixIcon: InkWell(
          hoverColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            widget.onSearch(_controller.text);
          },
          child: const Icon(Icons.search, size: 30),
        ),
      ),
    );
  }
}
