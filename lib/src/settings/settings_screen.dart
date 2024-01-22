import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/server_repository.dart';
import 'general/general_settings_form.dart';
import 'profiles/profiles_settings_form.dart';
import 'server/server_settings_form.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasServerRepo = false;
    try {
      RepositoryProvider.of<ServerRepository>(context);
      hasServerRepo = true;
    } catch (_) {}

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const GeneralSettingsForm(),
          if (hasServerRepo) const ServerSettingsForm(),
          const ProfilesSettingsForm(),
        ],
      ),
    );
  }
}
