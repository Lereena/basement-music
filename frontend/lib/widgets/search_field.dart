import 'package:flutter/material.dart';
import 'package:outline_search_bar/outline_search_bar.dart';

class SearchField extends StatelessWidget {
  final Function(String) onSearch;
  final TextEditingController controller;

  const SearchField({super.key, required this.onSearch, required this.controller});

  @override
  Widget build(BuildContext context) {
    return OutlineSearchBar(
      borderColor: Theme.of(context).primaryColor,
      searchButtonIconColor: Theme.of(context).primaryColor,
      clearButtonColor: Theme.of(context).primaryColor.withOpacity(0.3),
      clearButtonIconColor: Theme.of(context).backgroundColor,
      textEditingController: controller,
      onTypingFinished: onSearch,
      onSearchButtonPressed: onSearch,
    );
  }
}