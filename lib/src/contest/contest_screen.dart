import 'package:flutter/material.dart';

class ContestScreen extends StatelessWidget {
  const ContestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Contest')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: _ContestForm(),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: _CallLog(),
              ),
            ],
          ),
        ),
      );
}

class _ContestForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Callsign',
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: '59',
                  decoration: const InputDecoration(
                    labelText: 'RST-sent',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: '59',
                  decoration: const InputDecoration(
                    labelText: 'RST-rcvd',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Data-sent',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Data-rcvd',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              child: const Text('Add'),
              onPressed: () {},
            ),
          ),
        ],
      );
}

class _CallLog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PaginatedDataTable(
        columns: const [
          DataColumn(label: Text('Callsign')),
        ],
        source: _ContestDataSource(),
      );
}

class _ContestDataSource extends DataTableSource {
  @override
  DataRow? getRow(int index) => const DataRow(
        cells: [
          DataCell(Text('K3JX')),
        ],
      );

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => 100;

  @override
  int get selectedRowCount => 0;
}
