import 'package:basement_music/routing/routes.dart';
import 'package:basement_music/theme/theme.dart';
import 'package:basement_music/utils/horizontal_space_reducer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: HorizontalSpaceReducer(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _UploadOption(
                  icon: Icons.upload_file_outlined,
                  title: 'Upload from device',
                  subtitle: 'Pick an audio file from this device',
                  onTap: () => context.go(RouteName.uploadFromDevice),
                ),
                const SizedBox(height: AppSpacing.md),
                _UploadOption(
                  icon: Icons.travel_explore,
                  title: 'Search Soulseek',
                  subtitle: 'Find and import tracks from the Soulseek network',
                  onTap: () => context.go(RouteName.uploadFromSoulseek),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UploadOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _UploadOption({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: colorScheme.primaryContainer,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Icon(icon, size: 32, color: colorScheme.onPrimaryContainer),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(color: colorScheme.onPrimaryContainer),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.chevron_right, color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7)),
            ],
          ),
        ),
      ),
    );
  }
}
