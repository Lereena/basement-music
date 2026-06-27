import 'package:basement_music/widgets/page_title.dart';
import 'package:flutter/material.dart';

class BasementAppBar extends AppBar {
  BasementAppBar({super.key, required String title, super.actions, super.scrolledUnderElevation})
    : super(title: PageTitle(title), centerTitle: true);
}
