import 'package:basement_music/bloc/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension HomePageTitle on HomePage {
  String get title => switch (this) {
    HomePage.allTracks => 'All tracks',
    HomePage.favourites => 'Favourites',
  };
}

class HomePageSettingLine extends StatelessWidget {
  const HomePageSettingLine({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          Text('Home page', style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return DropdownButton<HomePage>(
                value: state.homePage,
                items: HomePage.values
                    .map((p) => DropdownMenuItem(value: p, child: Text(p.title)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) settingsCubit.setHomePage(value);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
