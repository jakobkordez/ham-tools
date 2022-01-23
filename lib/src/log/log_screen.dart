import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ham_tools/src/models/log_entry.dart';
import 'package:intl/intl.dart';

import 'bloc/log_bloc.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Log Book')),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: const [
              NewLogEntry(),
              SizedBox(height: 15),
              Expanded(child: LogList()),
            ],
          ),
        ),
      );
}

class NewLogEntry extends StatelessWidget {
  const NewLogEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: TextFormField(
                        enabled: false,
                        textAlign: TextAlign.center,
                        initialValue:
                            '${formatDate(DateTime.now())} ${formatTime(DateTime.now())}',
                        decoration:
                            const InputDecoration(labelText: 'Date & Time'),
                      )),
                  const SizedBox(width: 5),
                  ElevatedButton(onPressed: () {}, child: const Text('Now')),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Callsign'),
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<Mode>(
                      decoration: const InputDecoration(labelText: 'Mode'),
                      onChanged: (value) {},
                      items: Mode.values
                          .map((e) => DropdownMenuItem(
                                child: Text(describeEnum(e).toUpperCase()),
                                value: e,
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Power', suffixText: 'W'),
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'RST rec',
                    ),
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'RST sent',
                    ),
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'QTH',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Frequency', suffixText: 'Hz'),
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Note',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

class LogList extends StatefulWidget {
  const LogList({Key? key}) : super(key: key);

  @override
  State<LogList> createState() => _LogListState();
}

class _LogListState extends State<LogList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_isBottom) context.read<LogBloc>().add(LogFetched());
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  static const _colls = [
    Coll('#', 1),
    Coll('Date'),
    Coll('Time', 1),
    Coll('Callsign'),
    Coll('Mode', 1),
    Coll('Frequency', 3),
    Coll('Power'),
    Coll('RSTr', 1),
    Coll('RSTs', 1),
    Coll('QTH'),
    Coll('Name'),
    Coll('Note', 4),
  ];

  @override
  Widget build(BuildContext context) => Card(
        elevation: 2,
        child: Column(
          children: [
            DefaultTextStyle(
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
              child: Row(
                children: _colls
                    .map((e) => Expanded(
                        flex: e.flex,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 16,
                          ),
                          child: Center(child: Text(e.label)),
                        )))
                    .toList(),
              ),
            ),
            const Divider(height: 0, color: Colors.grey),
            Expanded(
              child: BlocBuilder<LogBloc, LogState>(
                builder: (context, state) {
                  if (state.status == LogStatus.intial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.separated(
                    controller: _scrollController,
                    itemCount: state.logEntries.length +
                        (state.hasReachedLast ? 0 : 1),
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemBuilder: (context, index) {
                      if (index >= state.logEntries.length) {
                        return const Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final e = state.logEntries[index];
                      final colVals = [
                        '${e.id}',
                        formatDate(e.time.toUtc()),
                        formatTime(e.time.toUtc()),
                        e.callsign,
                        describeEnum(e.mode).toUpperCase(),
                        '${formatFreq(e.frequency)} Hz',
                        '${e.power} W',
                        e.rstR,
                        e.rstS,
                        e.qth,
                        e.name,
                        e.note,
                      ];

                      return Row(
                        children: [
                          for (int i = 0; i < _colls.length; ++i)
                            Expanded(
                              flex: _colls[i].flex,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 16,
                                ),
                                child: Center(
                                  child: Text(colVals[i]),
                                ),
                              ),
                            )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
}

String formatDate(DateTime dt) => DateFormat.yMd().format(dt);

String formatTime(DateTime dt) {
  final h = '${dt.hour}'.padLeft(2, '0');
  final m = '${dt.minute}'.padLeft(2, '0');
  return '$h$m';
}

String formatFreq(int f) => NumberFormat('###,###,###,###').format(f);

class Coll {
  final String label;
  final int flex;

  const Coll(this.label, [this.flex = 2]);
}
