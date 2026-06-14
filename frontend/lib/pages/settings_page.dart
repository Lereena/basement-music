import 'package:basement_music/bloc/admin_cubit/admin_cubit.dart';
import 'package:basement_music/bloc/auth_cubit/auth_cubit.dart';
import 'package:basement_music/repositories/admin_repository.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:basement_music/widgets/settings/admin_section.dart';
import 'package:basement_music/widgets/settings/cache_all_tracks_settings_line.dart';
import 'package:basement_music/widgets/settings/theme_setting_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: BasementAppBar(title: 'Settings'),
      body: HorizontalSpaceReducer(
        child: ListView(
          children: [
            const Divider(),
            const ThemeSettingLine(),
            const Divider(),
            if (!kIsWeb) ...[const CacheAllTracksSettingsLine(), const Divider()],
            ListTile(
              leading: Icon(Icons.logout, color: theme.colorScheme.error),
              title: Text('Sign out', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error)),
              onTap: () => context.read<AuthCubit>().signOut(),
            ),
            const Divider(),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) => state.maybeWhen(
                authenticated: (user) => user.isAdmin
                    ? Column(
                        children: [
                          const SizedBox(height: 16),
                          BlocProvider(
                            create: (_) => AdminCubit(context.read<AdminRepository>())..loadCodes(),
                            child: const AdminSection(),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
