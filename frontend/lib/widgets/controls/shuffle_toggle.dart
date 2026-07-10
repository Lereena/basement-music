import 'package:basement_music/bloc/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShuffleToggle extends StatelessWidget {
  final double size;

  const ShuffleToggle({super.key, this.size = 30});

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();

    return InkWell(
      onTap: () => settingsCubit.setShuffle(!settingsCubit.state.shuffle),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Icon(state.shuffle ? Icons.shuffle_on_outlined : Icons.shuffle, size: size);
        },
      ),
    );
  }
}
