import 'package:basement_music/bloc/admin_cubit/admin_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserManagementSection extends StatelessWidget {
  const UserManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'User management',
            style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: const Text('Generate registration code'),
          onTap: () => context.read<AdminCubit>().generateCode(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text('Registration codes', style: theme.textTheme.labelLarge),
        ),
        BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) => state.when(
            initial: () => const SizedBox.shrink(),
            loadInProgress: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            loaded: (codes) => codes.isEmpty
                ? const Padding(padding: EdgeInsets.all(16), child: Text('No codes yet'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: codes.length,
                    itemBuilder: (_, i) {
                      final code = codes[i];

                      return ListTile(
                        dense: true,
                        leading: Icon(
                          code.isUsed ? Icons.check_circle : Icons.circle_outlined,
                          color: code.isUsed ? Colors.green : null,
                          size: 18,
                        ),
                        title: Text(code.code, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
                        subtitle: code.isUsed ? Text('Used by: ${code.usedByEmail}') : const Text('Unused'),
                        trailing: Opacity(
                          opacity: code.isUsed ? 0 : 1,
                          child: IconButton(
                            icon: const Icon(Icons.copy, size: 18),
                            tooltip: 'Copy code',
                            onPressed: code.isUsed
                                ? null
                                : () async {
                                    await Clipboard.setData(ClipboardData(text: code.code));

                                    if (!context.mounted) return;

                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(const SnackBar(content: Text('Code copied to clipboard')));
                                  },
                          ),
                        ),
                      );
                    },
                  ),
            error: () => const Padding(padding: EdgeInsets.all(16), child: Text('Failed to load codes.')),
          ),
        ),
      ],
    );
  }
}
