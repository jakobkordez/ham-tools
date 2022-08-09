import 'package:flutter/material.dart';

import 'server_settings_form.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            _SettingsCard(
              title: Text('Server'),
              body: ServerSettingsForm(),
            ),
          ],
        ),
      );
}

class _SettingsCard extends StatelessWidget {
  final Widget title;
  final Widget body;

  const _SettingsCard({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.titleLarge!,
                    child: title,
                  ),
                  const Divider(),
                  body,
                ],
              ),
            ),
          ),
        ),
      );
}
