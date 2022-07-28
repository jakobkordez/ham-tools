import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../models/log_entry.dart';
import '../utils/color_util.dart';
import 'cubit/stats_cubit.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => StatsCubit(),
        child: Scaffold(
          appBar: AppBar(title: const Text('QSO stats')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: BlocListener<StatsCubit, StatsState>(
                  listenWhen: (previous, current) =>
                      previous.error != current.error,
                  listener: (context, state) {
                    if (state.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error!),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Row(
                        children: [
                          if (!kIsWeb) Expanded(child: _LotwInput()),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: _OpenFile(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _AdiInput(),
                      const SizedBox(height: 10),
                      _Counter(),
                      const SizedBox(height: 20),
                      _ParseButton(),
                      _QsoData(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _DataCard extends StatelessWidget {
  final Map<String, int> data;
  final Map<String, Color?>? colors;
  final int sum;

  _DataCard({
    Key? key,
    required this.data,
    this.colors,
  })  : sum = data.values.reduce((a, b) => a + b),
        super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Table(
                columnWidths: const {
                  1: FixedColumnWidth(20),
                },
                defaultColumnWidth: const IntrinsicColumnWidth(),
                children: data.entries
                    .map((e) => TableRow(children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(e.key),
                          ),
                          const SizedBox.shrink(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text('${e.value}'),
                          ),
                        ]))
                    .toList(),
              ),
              const SizedBox(width: 15),
              SizedBox(
                height: 280,
                width: 280,
                child: PieChart(PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: data.entries
                      .map((e) => PieChartSectionData(
                            value: e.value + 0,
                            title: e.value > (sum ~/ 95) ? e.key : '',
                            color: colors?[e.key] ??
                                ColorUtil.randomPrimary(e.key.hashCode),
                            titlePositionPercentageOffset: 1.5,
                          ))
                      .toList(),
                )),
              ),
            ],
          ),
        ),
      );
}

class _LotwInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            'Fetch QSO\'s from LOTW',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 5),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
            columnWidths: const {
              1: FixedColumnWidth(10),
              2: IntrinsicColumnWidth(),
            },
            children: [
              TableRow(
                children: [
                  _LotwUsername(),
                  const SizedBox.shrink(),
                  const SizedBox.shrink(),
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 10),
                  SizedBox.shrink(),
                  SizedBox.shrink(),
                ],
              ),
              TableRow(
                children: [
                  _LotwPassword(),
                  const SizedBox.shrink(),
                  _LotwSubmit(),
                ],
              ),
            ],
          )
        ],
      );
}

class _LotwUsername extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<StatsCubit, StatsState>(
        buildWhen: (previous, current) =>
            previous.lotwUsername != current.lotwUsername,
        builder: (context, state) => TextFormField(
          initialValue: state.lotwUsername,
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) =>
              context.read<StatsCubit>().updateLotwUsername(value),
        ),
      );
}

class _LotwPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<StatsCubit, StatsState>(
        buildWhen: (previous, current) =>
            previous.lotwPassword != current.lotwPassword,
        builder: (context, state) => TextFormField(
          initialValue: state.lotwPassword,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) =>
              context.read<StatsCubit>().updateLotwPassword(value),
        ),
      );
}

class _LotwSubmit extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () => context.read<StatsCubit>().fetchLotw(),
        child: const Text('Submit'),
      );
}

class _OpenFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
        onPressed: () {
          final cubit = context.read<StatsCubit>();

          Future(() async {
            final result = await FilePicker.platform.pickFiles();
            final data = result?.files.single.bytes;
            if (data != null) {
              final adi = String.fromCharCodes(data);
              cubit.updateAdi(adi, true);
              return;
            }
            final path = result?.files.single.path;
            if (path != null) {
              final adi = await File(path).readAsString();
              cubit.updateAdi(adi, true);
              return;
            }
          });
        },
        icon: const Icon(Icons.file_open),
        label: const Text('Open ADI file'),
      );
}

class _AdiInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<StatsCubit, StatsState>(
        buildWhen: (previous, current) =>
            previous.adi != current.adi || previous.adiKey != current.adiKey,
        builder: (context, state) => TextFormField(
          key: state.adiKey,
          enabled: state.adi.length <= 5000,
          initialValue: state.adi.length <= 5000
              ? state.adi
              : '${state.adi.substring(0, 5000)}\n...',
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: const InputDecoration(
            labelText: 'ADIF data',
            border: OutlineInputBorder(),
          ),
          maxLines: 8,
          onChanged: (value) => context.read<StatsCubit>().updateAdi(value),
        ),
      );
}

class _Counter extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<StatsCubit, StatsState>(
        buildWhen: (previous, current) => previous.adi != current.adi,
        builder: (context, state) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Length: ${NumberFormat().format(state.adi.length)}'),
            if (state.adi.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextButton.icon(
                  onPressed: () =>
                      context.read<StatsCubit>().updateAdi('', true),
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
              ),
          ],
        ),
      );
}

class _ParseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () => context.read<StatsCubit>().parse(),
        child: const Text('Parse'),
      );
}

class _QsoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<StatsCubit, StatsState>(
        buildWhen: (previous, current) => previous.qsoStats != current.qsoStats,
        builder: (context, state) => state.qsoStats == null
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state.qsoStats!.mode.isNotEmpty)
                      _DataCard(data: state.qsoStats!.mode),
                    if (state.qsoStats!.band.isNotEmpty)
                      _DataCard(
                        data: state.qsoStats!.band,
                        colors: state.qsoStats!.band.map((band, _) =>
                            MapEntry(band, BandUtil.tryParse(band)?.color)),
                      ),
                  ],
                ),
              ),
      );
}
