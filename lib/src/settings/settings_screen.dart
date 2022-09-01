import 'package:flutter/material.dart';

import 'general/general_settings_form.dart';
import 'profiles/profiles_settings_form.dart';
import 'server/server_settings_form.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            GeneralSettingsForm(),
            ServerSettingsForm(),
            ProfilesSettingsForm(),
          ],
        ),
      );
}
