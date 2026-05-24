import 'package:basement_music/bloc/auth_cubit/auth_cubit.dart';
import 'package:basement_music/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCodePage extends StatefulWidget {
  const RegisterCodePage({super.key});

  @override
  State<RegisterCodePage> createState() => _RegisterCodePageState();
}

class _RegisterCodePageState extends State<RegisterCodePage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasementAppBar(title: 'Registration'),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter your invitation code to continue.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(labelText: 'Invitation code', border: OutlineInputBorder()),
                  autofocus: true,
                  onSubmitted: (_) => _submit(context),
                ),
                const SizedBox(height: 16),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      error: (msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg))),
                      orElse: () {},
                    );
                  },
                  builder: (context, state) {
                    final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
                    if (isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return FilledButton(onPressed: () => _submit(context), child: const Text('Submit'));
                  },
                ),
                const SizedBox(height: 8),
                TextButton(onPressed: () => context.read<AuthCubit>().signOut(), child: const Text('Sign out')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    final code = _controller.text.trim();
    if (code.isNotEmpty) {
      context.read<AuthCubit>().register(code);
    }
  }
}
