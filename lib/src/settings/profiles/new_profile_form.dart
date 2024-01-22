import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/field_controller.dart';
import '../../models/dxcc_entity.dart';
import '../../utils/text_input_formatters.dart';
import 'cubit/new_profile_cubit.dart';
import 'cubit/profiles_cubit.dart';

class NewProfileForm extends StatelessWidget {
  const NewProfileForm({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => NewProfileCubit(context.read<ProfilesCubit>()),
        child: const _NewProfileForm(),
      );
}

class _NewProfileForm extends StatelessWidget {
  const _NewProfileForm();

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(30),
        children: [
          Text(
            'New Profile',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _ProfileName()),
              const SizedBox(width: 10),
              Expanded(child: _Callsign()),
            ],
          ),
          const SizedBox(height: 30),
          _DxccDropdown(),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: _DxccCode()),
              const SizedBox(width: 10),
              Expanded(child: _CqZone()),
              const SizedBox(width: 10),
              Expanded(child: _ItuZone()),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: _Name()),
              const SizedBox(width: 10),
              Expanded(child: _Gridsquare()),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(flex: 5, child: _Qth()),
              const SizedBox(width: 10),
              Expanded(child: _State()),
            ],
          ),
          const SizedBox(height: 10),
          _Country(),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                context.read<NewProfileCubit>().submit();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ),
        ],
      );
}

class _ProfileName extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _FieldController(
        getValue: (state) => state.profileName,
        builder: (context, controller) => TextField(
          controller: controller,
          onChanged: context.read<NewProfileCubit>().setProfileName,
          decoration: const InputDecoration(
            labelText: 'Profile name',
          ),
        ),
      );
}

class _Callsign extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _FieldController(
        getValue: (state) => state.callsign,
        builder: (context, controller) => TextField(
          controller: controller,
          onChanged: context.read<NewProfileCubit>().setCallsign,
          inputFormatters: [UpperCaseTextFormatter()],
          decoration: const InputDecoration(
            labelText: 'Callsign',
          ),
        ),
      );
}

class _DxccDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NewProfileCubit, NewProfileState>(
        buildWhen: (previous, current) =>
            previous.dxccEntity != current.dxccEntity,
        builder: (context, state) => DropdownButtonFormField(
          decoration: const InputDecoration(
            labelText: 'DXCC Entity',
          ),
          value: state.dxccEntity?.dxcc,
          items: DxccEntity.dxccs
                  .map((dxcc) => DropdownMenuItem(
                        value: dxcc.dxcc,
                        child: Text(dxcc.name),
                      ))
                  .toList() +
              const [
                DropdownMenuItem(
                  value: 0,
                  child: Text('NON-DXCC'),
                ),
              ],
          onChanged: (value) =>
              context.read<NewProfileCubit>().setDxcc('${value ?? 0}'),
        ),
      );
}

class _DxccCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _FieldController(
        getValue: (state) => state.dxcc,
        builder: (context, controller) => TextField(
          controller: controller,
          onChanged: context.read<NewProfileCubit>().setDxcc,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'DXCC Code',
          ),
        ),
      );
}

class _CqZone extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _FieldController(
        getValue: (state) => state.cqZone,
        builder: (context, controller) =>
            BlocBuilder<NewProfileCubit, NewProfileState>(
          buildWhen: (previous, current) =>
              previous.dxccEntity != current.dxccEntity,
          builder: (context, state) => TextField(
            controller: controller,
            onChanged: context.read<NewProfileCubit>().setCqZone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'CQ Zone',
              hintText: state.dxccEntity?.cqZone.toString(),
            ),
          ),
        ),
      );
}

class _ItuZone extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _FieldController(
        getValue: (state) => state.ituZone,
        builder: (context, controller) =>
            BlocBuilder<NewProfileCubit, NewProfileState>(
          buildWhen: (previous, current) =>
              previous.dxccEntity != current.dxccEntity,
          builder: (context, state) => TextField(
            controller: controller,
            onChanged: context.read<NewProfileCubit>().setItuZone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'ITU Zone',
              hintText: state.dxccEntity?.ituZone.toString(),
            ),
          ),
        ),
      );
}

class _Name extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _FieldController(
        getValue: (state) => state.name,
        builder: (context, controller) => TextField(
          controller: controller,
          onChanged: context.read<NewProfileCubit>().setName,
          decoration: const InputDecoration(
            labelText: 'Station / Operator Name',
          ),
        ),
      );
}

class _Gridsquare extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _FieldController(
        getValue: (state) => state.gridsquare,
        builder: (context, controller) => TextField(
          controller: controller,
          onChanged: context.read<NewProfileCubit>().setGridsquare,
          decoration: const InputDecoration(
            labelText: 'Gridsquare',
          ),
        ),
      );
}

class _Qth extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _FieldController(
        getValue: (state) => state.qth,
        builder: (context, controller) => TextField(
          controller: controller,
          onChanged: context.read<NewProfileCubit>().setQth,
          decoration: const InputDecoration(
            labelText: 'QTH',
          ),
        ),
      );
}

class _State extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _FieldController(
        getValue: (state) => state.state,
        builder: (context, controller) => TextField(
          controller: controller,
          onChanged: context.read<NewProfileCubit>().setState,
          decoration: const InputDecoration(
            labelText: 'State',
          ),
        ),
      );
}

class _Country extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _FieldController(
        getValue: (state) => state.country,
        builder: (context, controller) => TextField(
          controller: controller,
          onChanged: context.read<NewProfileCubit>().setCountry,
          decoration: const InputDecoration(
            labelText: 'Country',
          ),
        ),
      );
}

typedef _FieldController = FieldController<NewProfileCubit, NewProfileState>;
