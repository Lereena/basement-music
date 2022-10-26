import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings_bloc/settings_bloc.dart';
import 'settings_line_decoration.dart';

class ServerSettingLine extends StatelessWidget {
  const ServerSettingLine({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final controller = TextEditingController(text: settingsBloc.state.serverAddress);

    return SettingsLineDecoration(
      child: InkWell(
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              const Text('Server host'),
              const Spacer(),
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  return Text(state.serverAddress);
                },
              ),
            ],
          ),
        ),
        onTap: () => showDialog(
          context: context,
          builder: (context) => Dialog(
            child: TextField(
              controller: controller,
              onEditingComplete: () => settingsBloc.add(
                SetServerAddress(controller.text),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
