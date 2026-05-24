import 'package:basement_music/bloc/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.library_music, size: 80),
              const SizedBox(height: 16),
              Text('Basement Music', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 48),
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
                    return const CircularProgressIndicator();
                  }
                  return FilledButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text('Sign in with Google'),
                    onPressed: () => context.read<AuthCubit>().signInWithGoogle(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
