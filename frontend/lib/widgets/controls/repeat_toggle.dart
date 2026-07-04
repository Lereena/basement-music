import 'package:basement_music/bloc/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RepeatToggle extends StatelessWidget {
  final double size;

  const RepeatToggle({super.key, this.size = 30});

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();

    return InkWell(
      onTap: () => settingsCubit.setRepeat(!settingsCubit.state.repeat),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Icon(state.repeat ? Icons.repeat_on_outlined : Icons.repeat, size: size);
        },
      ),
    );
  }
}
