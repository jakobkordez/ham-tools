import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/log_entry.dart';
import '../utils/adif.dart';
import '../utils/log_entry_list_util.dart';
import '../utils/text_input_formatters.dart';
import 'qsl_csv_gen.dart';

class QslScreen extends StatefulWidget {
  const QslScreen({super.key});

  @override
  State<QslScreen> createState() => _QslScreenState();
}

class _QslScreenState extends State<QslScreen> {
  static const columns = [
    DataColumn(label: Text('Station')),
    DataColumn(label: Text('Date')),
    DataColumn(label: Text('Time')),
    DataColumn(label: Text('Call')),
    DataColumn(label: Text('Freq')),
    DataColumn(label: Text('Mode')),
    DataColumn(label: Text('RST')),
    DataColumn(label: Text('Power')),
    DataColumn(label: Text('QSL S')),
    DataColumn(label: Text('QSL R')),
  ];

  final _filterController = TextEditingController();
  List<LogEntry>? _logEntries;
  List<LogEntry>? _filteredLogEntries;
  Set<LogEntry> _selectedLogEntries = {};

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('QSL CSV')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              // constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  _OpenFile(
                    onOpen: (data) => setState(() {
                      _logEntries = Adif.decodeAdi(data)
                          .map((e) => LogEntry.fromAdiMap(e))
                          .toList()
                        ..sortByTime();
                      _filteredLogEntries = _filteredLogEntries = _logEntries
                          ?.where((e) => e.callsign
                              .toUpperCase()
                              .contains(_filterController.text))
                          .toList();
                      _selectedLogEntries = {};
                    }),
                  ),
                  const SizedBox(height: 20),
                  if (_filteredLogEntries != null)
                    PaginatedDataTable(
                      header: const Text('All QSO\'s'),
                      actions: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _filterController,
                            inputFormatters: [UpperCaseTextFormatter()],
                            decoration: const InputDecoration(
                                labelText: 'Filter',
                                border: OutlineInputBorder()),
                            onChanged: (value) => setState(() {
                              _filteredLogEntries = _logEntries
                                  ?.where((e) =>
                                      e.callsign.toUpperCase().contains(value))
                                  .toList();
                            }),
                          ),
                        ),
                      ],
                      source: _DataSource(
                        logEntries: _filteredLogEntries!,
                        onSelectChanged: (e, value) => setState(() {
                          if (value == null) return;
                          if (value) {
                            _selectedLogEntries.add(e);
                          } else {
                            _selectedLogEntries.remove(e);
                          }
                        }),
                        selected: _selectedLogEntries,
                      ),
                      columns: columns,
                    ),
                  const SizedBox(height: 20),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Text(
                                'Selected QSO\'s',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const Expanded(child: SizedBox.shrink()),
                              ElevatedButton.icon(
                                onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => _ExportDialog(
                                          selected: _selectedLogEntries,
                                        )),
                                icon: const Icon(Icons.view_list),
                                label: const Text('CSV'),
                              ),
                            ],
                          ),
                        ),
                        Scrollbar(
                          child: SingleChildScrollView(
                            primary: true,
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columns: columns,
                                rows: _selectedLogEntries
                                    .map((e) => DataRow(cells: [
                                          DataCell(Text(e.stationCall ??
                                              e.operatorCall ??
                                              '?')),
                                          DataCell(Text(e.dateOnString)),
                                          DataCell(Text(e.timeOnString)),
                                          DataCell(Text(e.callsign)),
                                          DataCell(Text(e.freqMhz)),
                                          DataCell(Text((e.subMode ?? e.mode)
                                              .name
                                              .toUpperCase())),
                                          DataCell(Text(e.rstSent ?? '')),
                                          DataCell(Text(e.power == null
                                              ? ''
                                              : '${e.power} W')),
                                          DataCell(
                                              Text(e.qslSent?.label ?? '')),
                                          DataCell(
                                              Text(e.qslRcvd?.label ?? '')),
                                        ]))
                                    .toList()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _DataSource extends DataTableSource {
  final List<LogEntry> logEntries;
  final Set<LogEntry> selected;
  final void Function(LogEntry entry, bool? value) onSelectChanged;

  _DataSource({
    required this.logEntries,
    required this.selected,
    required this.onSelectChanged,
  });

  @override
  DataRow? getRow(int index) {
    final e = logEntries[index];

    return DataRow(
      selected: selected.contains(e),
      onSelectChanged: (value) => onSelectChanged(e, value),
      cells: [
        DataCell(Text(e.stationCall ?? e.operatorCall ?? '?')),
        DataCell(Text(e.dateOnString)),
        DataCell(Text(e.timeOnString)),
        DataCell(Text(e.callsign)),
        DataCell(Text(e.freqMhz)),
        DataCell(Text((e.subMode ?? e.mode).name.toUpperCase())),
        DataCell(Text(e.rstSent ?? '')),
        DataCell(Text(e.power == null ? '' : '${e.power} W')),
        DataCell(Text(e.qslSent?.label ?? '')),
        DataCell(Text(e.qslRcvd?.label ?? '')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => logEntries.length;

  @override
  int get selectedRowCount => selected.length;
}

class _ExportDialog extends StatefulWidget {
  final Set<LogEntry> selected;

  const _ExportDialog({
    required this.selected,
  });

  @override
  State<_ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<_ExportDialog> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = generateQslCsv(widget.selected.toList());
  }

  @override
  Widget build(BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CSV',
                ),
                maxLines: 20,
                controller: _controller,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      try {
                        Clipboard.setData(
                            ClipboardData(text: _controller.text));
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                    icon: const Icon(Icons.content_copy),
                    label: const Text('Copy'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        final path = await FilePicker.platform.saveFile(
                          dialogTitle: 'Export QSO\'s',
                          fileName: 'qsl.csv',
                          type: FileType.any,
                        );
                        if (path == null) return;
                        await File(path).writeAsString(_controller.text);
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

class _OpenFile extends StatelessWidget {
  final void Function(String data) onOpen;

  const _OpenFile({required this.onOpen});

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
        onPressed: () {
          Future(() async {
            final result = await FilePicker.platform.pickFiles();
            final data = result?.files.single.bytes;
            if (data != null) {
              final adi = String.fromCharCodes(data);
              onOpen(adi);
              return;
            }
            final path = result?.files.single.path;
            if (path != null) {
              final adi = await File(path).readAsString();
              onOpen(adi);
              return;
            }
          });
        },
        icon: const Icon(Icons.file_open),
        label: const Text('Open ADI file'),
      );
}
