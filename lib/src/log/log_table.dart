import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ham_tools/src/models/log_entry.dart';
import 'package:ham_tools/src/utils/callsign_util.dart';

import 'bloc/log_bloc.dart';

class LogTable extends StatelessWidget {
  static const headStyle = TextStyle(fontWeight: FontWeight.bold);

  const LogTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<LogBloc, LogState>(
        builder: (context, state) => PaginatedDataTable(
          header: Text(
            'Log',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          columnSpacing: 10,
          dataRowHeight: 30,
          rowsPerPage: 20,
          columns: const [
            DataColumn(label: Text('Date', style: headStyle)),
            DataColumn(label: Text('Time', style: headStyle)),
            DataColumn(label: Text('Call', style: headStyle)),
            DataColumn(label: Text('Freq', style: headStyle)),
            DataColumn(label: Text('Mode', style: headStyle)),
            DataColumn(label: Text('Flag', style: headStyle)),
            DataColumn(label: Text('Country', style: headStyle)),
            DataColumn(label: Text('Name', style: headStyle)),
            DataColumn(label: Text('Notes', style: headStyle)),
          ],
          source: DataSource(state.logEntries),
        ),
      );
}

class DataSource extends DataTableSource {
  static const callsignStyle = TextStyle(fontFamily: 'RobotoMono');

  final List<LogEntry> data;

  DataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final e = data[index];
    final dxcc = DxccEntity.findSub(e.callsign);

    return DataRow(cells: [
      DataCell(Text(e.dateOnString)),
      DataCell(Text(e.timeOnString)),
      DataCell(Text(e.callsign, style: callsignStyle)),
      DataCell(Text(e.freqMhz)),
      DataCell(Text(e.mode.name.toUpperCase())),
      DataCell(Material(
        color: Colors.grey.withAlpha(50),
        child: dxcc != null
            ? Center(child: Image.asset('assets/flags/64/${dxcc.flag}.png'))
            : const SizedBox.expand(),
      )),
      DataCell(Text(
        dxcc?.name ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      )),
      DataCell(Text(
        e.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      )),
      DataCell(Text(e.notes)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
