import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/settings_cubit.dart';
import '../settings_card.dart';

class GeneralSettingsForm extends StatelessWidget {
  const GeneralSettingsForm({super.key});

  @override
  Widget build(BuildContext context) => SettingsCard(
        title: const Text('General'),
        child: Row(
          children: [
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) => Switch(
                value: state.themeMode == ThemeMode.dark,
                onChanged: (value) =>
                    context.read<SettingsCubit>().setDarkMode(value),
              ),
            ),
            const SizedBox(width: 10),
            const Text('Dark mode'),
          ],
        ),
      );
}
