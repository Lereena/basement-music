import 'package:flutter/material.dart';

import 'page_title.dart';

class BasementAppBar extends AppBar {
  BasementAppBar({required String title, super.actions})
      : super(
          title: PageTitle(title),
          centerTitle: true,
        );
}
