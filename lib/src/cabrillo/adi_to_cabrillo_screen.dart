import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/adi_to_cab_cubit.dart';

class AdiToCabrilloScreen extends StatelessWidget {
  const AdiToCabrilloScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Adi to Cabrillo')),
        body: BlocProvider(
          create: (context) => AdiToCabCubit(),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _OpenAdiFileButton(),
              const SizedBox(height: 10),
              _AdiFileField(),
            ],
          ),
        ),
      );
}

class _OpenAdiFileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
        onPressed: () {
          final cubit = context.read<AdiToCabCubit>();

          Future(() async {
            final result = await FilePicker.platform.pickFiles();
            final data = result?.files.single.bytes;
            if (data == null) return;
            final adi = String.fromCharCodes(data);
            cubit.updateAdiFile(adi, true);
          });
        },
        icon: const Icon(Icons.file_open),
        label: const Text('Open ADI file'),
      );
}

class _AdiFileField extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AdiToCabCubit, AdiToCabState>(
        buildWhen: (previous, current) => previous.adiFile != current.adiFile,
        builder: (context, state) => TextFormField(
          key: state.adiFormKey,
          initialValue: state.adiFile,
          maxLines: 10,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Adi File',
          ),
          onChanged: context.read<AdiToCabCubit>().updateAdiFile,
        ),
      );
}
