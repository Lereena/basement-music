import 'package:basement_music/bloc/soulseek_login_cubit/soulseek_login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SoulseekAdminSection extends StatefulWidget {
  const SoulseekAdminSection({super.key});

  @override
  State<SoulseekAdminSection> createState() => _SoulseekAdminSectionState();
}

class _SoulseekAdminSectionState extends State<SoulseekAdminSection> {
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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Soulseek',
            style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 12),
              BlocBuilder<SoulseekLoginCubit, SoulseekLoginState>(
                builder: (context, state) {
                  final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
                  final isConnected = state.maybeWhen(connected: (_) => true, orElse: () => false);
                  final cubit = context.read<SoulseekLoginCubit>();
                  return Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () => cubit.setCredentials(
                                  _usernameController.text.trim(),
                                  _passwordController.text,
                                ),
                        icon: isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.link),
                        label: const Text('Connect'),
                      ),
                      if (isConnected) ...[
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () => cubit.disconnect(),
                          icon: const Icon(Icons.link_off),
                          label: const Text('Disconnect'),
                        ),
                      ],
                      const SizedBox(width: 12),
                      Expanded(child: _StatusChip(state: state)),
                    ],
                  );
                },
              ),
            ],
          ),
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
        Flexible(child: Text(label, style: TextStyle(color: color), overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
