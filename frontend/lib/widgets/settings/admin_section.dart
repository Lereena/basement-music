import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:basement_music/bloc/admin_cubit/admin_cubit.dart';

class AdminSection extends StatelessWidget {
  const AdminSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Admin',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: const Text('Generate registration code'),
          onTap: () => context.read<AdminCubit>().generateCode(),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            'Registration codes',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) => state.when(
            initial: () => const SizedBox.shrink(),
            loadInProgress: () =>
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            loaded: (codes) => codes.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No codes yet.'),
                  )
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
                        title: Text(
                          code.code,
                          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                        ),
                        subtitle: code.isUsed
                            ? Text('Used by: ${code.usedByEmail}')
                            : const Text('Unused'),
                      );
                    },
                  ),
            error: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Failed to load codes.'),
            ),
          ),
        ),
      ],
    );
  }
}
