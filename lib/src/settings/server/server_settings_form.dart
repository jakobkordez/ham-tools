import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/server/role.dart';
import '../../repository/server_repository.dart';
import '../settings_card.dart';
import 'cubit/server_settings_cubit.dart';

class ServerSettingsForm extends StatelessWidget {
  const ServerSettingsForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SettingsCard(
        title: const Text('Server'),
        child: BlocProvider(
          create: (context) =>
              ServerSettingsCubit(serverRepo: context.read<ServerRepository>()),
          child: const _ServerSettingsForm(),
        ),
      );
}

class _ServerSettingsForm extends StatelessWidget {
  const _ServerSettingsForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: BlocConsumer<ServerSettingsCubit, ServerSettingsState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == ServerSettingsStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error ?? 'An error occurred'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            buildWhen: (previous, current) =>
                previous.isAuthenticated != current.isAuthenticated ||
                previous.status != current.status,
            builder: (context, state) => state.status ==
                    ServerSettingsStatus.initializing
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: state.isAuthenticated
                        ? [
                            Text('Server URL: ${state.serverUrl}'),
                            const SizedBox(height: 5),
                            Text('User: ${state.user?.username}'),
                            const SizedBox(height: 5),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runSpacing: 5,
                              spacing: 5,
                              children: [
                                const Text('Roles:'),
                                ...state.user?.roles
                                        .map((r) => Chip(label: Text(r.label)))
                                        .toList() ??
                                    [],
                              ],
                            ),
                            const Divider(),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: _Logout(),
                            ),
                          ]
                        : const [
                            _ServerUrl(),
                            _Username(),
                            _Password(),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: _Login(),
                            ),
                          ],
                  ),
          ),
        ),
      );
}

class _ServerUrl extends StatelessWidget {
  const _ServerUrl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ServerSettingsCubit, ServerSettingsState>(
        buildWhen: (previous, current) =>
            previous.serverUrl != current.serverUrl,
        builder: (context, state) => TextFormField(
          initialValue: state.serverUrl,
          decoration: const InputDecoration(
            labelText: 'Server URL',
          ),
          onChanged: context.read<ServerSettingsCubit>().setServer,
        ),
      );
}

class _Username extends StatelessWidget {
  const _Username({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ServerSettingsCubit, ServerSettingsState>(
        buildWhen: (previous, current) => previous.username != current.username,
        builder: (context, state) => TextFormField(
          initialValue: state.username,
          decoration: const InputDecoration(
            labelText: 'Username',
          ),
          onChanged: context.read<ServerSettingsCubit>().setUsername,
        ),
      );
}

class _Password extends StatelessWidget {
  const _Password({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ServerSettingsCubit, ServerSettingsState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) => TextFormField(
          initialValue: state.password,
          decoration: const InputDecoration(
            labelText: 'Password',
          ),
          obscureText: true,
          onChanged: context.read<ServerSettingsCubit>().setPassword,
        ),
      );
}

class _Login extends StatelessWidget {
  const _Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ServerSettingsCubit, ServerSettingsState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) =>
            state.status == ServerSettingsStatus.authenticating
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: context.read<ServerSettingsCubit>().submit,
                    child: const Text('Login'),
                  ),
      );
}

class _Logout extends StatelessWidget {
  const _Logout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: context.read<ServerSettingsCubit>().logout,
        child: const Text('Logout'),
      );
}
