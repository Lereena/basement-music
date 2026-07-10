import 'dart:async';

import 'package:basement_music/bloc/soulseek_login_cubit/soulseek_login_cubit.dart';
import 'package:basement_music/bloc/soulseek_settings_cubit/soulseek_settings_cubit.dart';
import 'package:basement_music/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SoulseekAdminSection extends StatefulWidget {
  const SoulseekAdminSection({super.key});

  @override
  State<SoulseekAdminSection> createState() => _SoulseekAdminSectionState();
}

class _SoulseekAdminSectionState extends State<SoulseekAdminSection> {
  Timer? _pollTimer;
  GoRouter? _router;

  bool _wasOnSettings = false;

  // The settings page lives in an indexedStack and stays mounted, so initState
  // fires only once. Listen to route changes to detect each (re)entry instead.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);

    if (_router != router) {
      _router?.routerDelegate.removeListener(_onRouteChanged);
      _router = router;
      _router!.routerDelegate.addListener(_onRouteChanged);
      _onRouteChanged();
    }
  }

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_onRouteChanged);
    _pollTimer?.cancel();
    super.dispose();
  }

  bool get _onSettings => _router?.routerDelegate.currentConfiguration.uri.path == RouteName.settings;

  void _onRouteChanged() {
    final onSettings = _onSettings;

    if (onSettings && !_wasOnSettings) {
      // Entered the settings page: refresh now and start polling.
      _refresh();
      _restartPoll();
    } else if (!onSettings && _wasOnSettings) {
      _pollTimer?.cancel();
    }

    _wasOnSettings = onSettings;
  }

  void _refresh() {
    context.read<SoulseekLoginCubit>().loadStatus();
    context.read<SoulseekSettingsCubit>().load();
  }

  void _restartPoll() {
    _pollTimer?.cancel();
    _scheduleNextPoll();
  }

  // Poll once per disconnect window; reschedule each tick so changes to the
  // setting take effect. Falls back to 10 min when auto-disconnect is off.
  void _scheduleNextPoll() {
    final minutes = context.read<SoulseekSettingsCubit>().state.minutes;
    if (minutes <= 0) return;

    _pollTimer = Timer(Duration(minutes: minutes), () {
      if (!mounted || !_onSettings) return;
      _refresh();
      _scheduleNextPoll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SoulseekLoginCubit>();
    final isConnected = cubit.state.maybeWhen(connected: (_) => true, orElse: () => false);

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                'Soulseek',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              _StatusChip(state: cubit.state),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isConnected) ...[
                ElevatedButton.icon(
                  onPressed: () => cubit.disconnect(),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error.withValues(alpha: 0.8),
                    foregroundColor: theme.colorScheme.surface,
                    side: BorderSide(color: theme.colorScheme.error, width: 2),
                  ),
                  icon: const Icon(Icons.link_off),
                  label: const Text('Disconnect'),
                ),
                SizedBox(height: 8),
              ],
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _openCredentialsDialog(context, cubit),
                    icon: const Icon(Icons.key),
                    label: const Text('Update credentials'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const _DisconnectAfterField(),
            ],
          ),
        ),
      ],
    );
  }

  void _openCredentialsDialog(BuildContext context, SoulseekLoginCubit cubit) {
    showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(value: cubit, child: const _CredentialsDialog()),
    );
  }
}

class _CredentialsDialog extends StatefulWidget {
  const _CredentialsDialog();

  @override
  State<_CredentialsDialog> createState() => _CredentialsDialogState();
}

class _CredentialsDialogState extends State<_CredentialsDialog> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SoulseekLoginCubit, SoulseekLoginState>(
      listenWhen: (prev, curr) => curr.maybeWhen(connected: (_) => true, orElse: () => false),
      listener: (context, state) => Navigator.of(context).pop(),
      child: AlertDialog(
        title: const Text('Soulseek credentials'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            BlocBuilder<SoulseekLoginCubit, SoulseekLoginState>(
              builder: (context, state) => state.maybeWhen(
                error: (message) => Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(message, style: const TextStyle(color: Colors.red)),
                ),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          BlocBuilder<SoulseekLoginCubit, SoulseekLoginState>(
            builder: (context, state) {
              final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
              final cubit = context.read<SoulseekLoginCubit>();

              return ElevatedButton.icon(
                onPressed: isLoading
                    ? null
                    : () => cubit.setCredentials(_usernameController.text.trim(), _passwordController.text),
                icon: isLoading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.link),
                label: const Text('Connect'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DisconnectAfterField extends StatefulWidget {
  const _DisconnectAfterField();

  @override
  State<_DisconnectAfterField> createState() => _DisconnectAfterFieldState();
}

class _DisconnectAfterFieldState extends State<_DisconnectAfterField> {
  final _controller = TextEditingController();
  int? _lastSyncedMinutes;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SoulseekSettingsCubit>();

    final theme = Theme.of(context);

    // Keep the field in sync with the fetched value without clobbering edits.
    if (_lastSyncedMinutes != cubit.state.minutes) {
      _lastSyncedMinutes = cubit.state.minutes;
      _controller.text = cubit.state.minutes.toString();
    }

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              label: Text('Disconnect after inactivity (in minutes)', style: theme.textTheme.bodyLarge),
              helperText: '0 = never',
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: cubit.state.loading
              ? null
              : () {
                  final minutes = int.tryParse(_controller.text.trim());
                  if (minutes != null && minutes >= 0) cubit.save(minutes);
                },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.state});

  final SoulseekLoginState state;

  @override
  Widget build(BuildContext context) {
    return state.when(
      initial: () => _chip(context, 'Disconnected', Colors.red, Icons.cancel),
      loading: () => _chip(context, 'Connecting…', Colors.orange, Icons.sync),
      connected: (username) => _chip(context, 'Connected as $username', Colors.green, Icons.check_circle),
      error: (message) => _chip(context, message, Colors.red, Icons.error),
    );
  }

  Widget _chip(BuildContext context, String label, Color color, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: TextStyle(color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
