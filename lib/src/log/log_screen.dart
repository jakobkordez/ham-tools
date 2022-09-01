import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/settings_cubit.dart';
import 'log_entry_form.dart';
import 'log_table.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Log Book'),
          actions: [
            BlocBuilder<SettingsCubit, SettingsState>(
              buildWhen: (previous, current) =>
                  previous.themeMode != current.themeMode,
              builder: (context, state) => IconButton(
                icon: state.themeMode == ThemeMode.dark
                    ? const Icon(Icons.light_mode)
                    : const Icon(Icons.dark_mode),
                onPressed: () =>
                    context.read<SettingsCubit>().toggleThemeMode(),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 1000) {
              return ListView(
                padding: const EdgeInsets.all(15),
                children: const [
                  LogEntryForm(),
                  SizedBox(height: 15),
                  LogTable(),
                ],
              );
            }

            return Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      primary: false,
                      child: LogEntryForm(),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      primary: false,
                      child: LogTable(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
}
