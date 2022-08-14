import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../settings_card.dart';
import 'cubit/profiles_cubit.dart';
import 'new_profile_form.dart';

class ProfilesSettingsForm extends StatelessWidget {
  const ProfilesSettingsForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SettingsCard(
        title: const Text('Profiles'),
        actions: [
          IconButton(
            splashRadius: 25,
            icon: const Icon(Icons.add),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const Dialog(child: NewProfileForm()),
            ),
          ),
        ],
        padding: EdgeInsets.zero,
        child: const _ProfilesList(),
      );
}

class _ProfilesList extends StatelessWidget {
  const _ProfilesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ProfilesCubit, ProfilesState>(
        builder: (context, state) {
          if (state is ProfilesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfilesError) {
            return Text(state.error);
          }

          if (state is ProfilesLoaded) {
            if (state.profiles.isEmpty) {
              return Text(
                'No profiles yet',
                style: Theme.of(context).textTheme.bodyLarge,
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.profiles.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                    '${state.profiles[index].profileName} (${state.profiles[index].callsign})'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  splashRadius: 20,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete profile'),
                      content: const Text(
                          'Are you sure you want to delete this profile?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<ProfilesCubit>()
                                .deleteProfile(state.profiles[index].id ?? '');
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.red,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          throw UnimplementedError();
        },
      );
}
