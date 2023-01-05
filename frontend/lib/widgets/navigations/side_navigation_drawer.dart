import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/navigation_cubit/navigation_cubit.dart';
import '../app_logo.dart';

class SideNavigationDrawer extends StatefulWidget {
  const SideNavigationDrawer({super.key});

  @override
  State<SideNavigationDrawer> createState() => _SideNavigationDrawerState();
}

class _SideNavigationDrawerState extends State<SideNavigationDrawer> {
  late final _navigationCubit = BlocProvider.of<NavigationCubit>(context);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const SizedBox(height: 20),
          const SizedBox(
            height: 100,
            child: AppLogo(),
          ),
          const SizedBox(height: 20),
          const Divider(indent: 10, endIndent: 10),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: _navigationCubit.state is NavigationTracks,
            onTap: () {
              Navigator.pop(context);
              _navigationCubit.navigateHome();
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_music),
            title: const Text('Library'),
            selected: _navigationCubit.state is NavigationLibrary,
            onTap: () {
              Navigator.pop(context);
              _navigationCubit.navigateLibrary();
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search'),
            selected: _navigationCubit.state is NavigationSearch,
            onTap: () {
              Navigator.pop(context);
              _navigationCubit.navigateSearch();
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload),
            title: const Text('Upload'),
            selected: _navigationCubit.state is NavigationUploadTrack,
            onTap: () {
              Navigator.pop(context);
              _navigationCubit.navigateUploadTrack();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings, size: 30),
            title: const Text('Settings'),
            selected: _navigationCubit.state is NavigationSettings,
            onTap: () {
              Navigator.pop(context);
              _navigationCubit.navigateSettings();
            },
          ),
        ],
      ),
    );
  }
}
