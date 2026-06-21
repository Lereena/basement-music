import 'package:basement_music/bloc/settings_cubit/settings_cubit.dart';
import 'package:basement_music/pages/favourites_page.dart';
import 'package:basement_music/pages/tracks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageWrapper extends StatelessWidget {
  const HomePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (prev, curr) => prev.homePage != curr.homePage,
      builder: (_, state) => state.homePage == HomePage.favourites
          ? const FavouritesPage()
          : const TracksPage(),
    );
  }
}
