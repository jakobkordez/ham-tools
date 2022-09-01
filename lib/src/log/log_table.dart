import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/log_entry.dart';
import '../models/dxcc_entity.dart';
import 'bloc/log_bloc.dart';
import 'cubit/log_table_cubit.dart';

class LogTable extends StatelessWidget {
  static const headStyle = TextStyle(fontWeight: FontWeight.bold);

  const LogTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => LogTableCubit(),
        child: BlocBuilder<LogBloc, LogState>(
          builder: (context, logState) =>
              BlocBuilder<LogTableCubit, LogTableState>(
            builder: (context, tableState) => PaginatedDataTable(
              showCheckboxColumn: tableState is LogTableDelete,
              header: Text(
                tableState is LogTableDelete ? 'Delete entries' : 'Log',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              columnSpacing: 10,
              dataRowHeight: 30,
              rowsPerPage: tableState.rowsPerPage,
              columns: const [
                DataColumn(label: Text('Date', style: LogTable.headStyle)),
                DataColumn(label: Text('Time', style: LogTable.headStyle)),
                DataColumn(label: Text('Call', style: LogTable.headStyle)),
                DataColumn(label: Text('Freq', style: LogTable.headStyle)),
                DataColumn(label: Text('Mode', style: LogTable.headStyle)),
                DataColumn(label: Text('Country', style: LogTable.headStyle)),
                DataColumn(label: Text('Name', style: LogTable.headStyle)),
                DataColumn(label: Text('Notes', style: LogTable.headStyle)),
              ],
              source: DataSource(
                logState.count,
                logState.logEntries,
                onSelectChanged: context.read<LogTableCubit>().setSelected,
                selected:
                    tableState is LogTableDelete ? tableState.selected : null,
              ),
              onPageChanged: (value) {
                context.read<LogTableCubit>().setCurrentPage(value);
                context
                    .read<LogBloc>()
                    .add(LogFetched(value, value + tableState.rowsPerPage));
              },
              showFirstLastButtons: true,
              actions: [
                if (tableState is LogTableDelete) ...[
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () =>
                        context.read<LogTableCubit>().toggleDeleteMode(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {},
                  ),
                ] else ...[
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        context.read<LogTableCubit>().toggleDeleteMode(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => context.read<LogBloc>().add(LogRefreshed(
                        tableState.currentPage + tableState.rowsPerPage)),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
}

class DataSource extends DataTableSource {
  static const callsignStyle = TextStyle(fontFamily: 'RobotoMono');

  final List<LogEntry> data;
  final int count;
  final void Function(String id, bool value)? onSelectChanged;
  final Set<String>? selected;

  DataSource(
    this.count,
    this.data, {
    this.onSelectChanged,
    this.selected,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final e = data[index];
    final dxcc = DxccEntity.findSub(e.callsign);

    return DataRow(
      selected: selected?.contains(e.id) ?? false,
      onSelectChanged: onSelectChanged != null
          ? (value) {
              if (value == null) return;
              onSelectChanged!(e.id, value);
            }
          : null,
      onLongPress: () {},
      cells: [
        DataCell(Text(e.dateOnString)),
        DataCell(Text(e.timeOnString)),
        DataCell(Text(e.callsign, style: callsignStyle)),
        DataCell(Text(e.freqMhz)),
        DataCell(Center(child: Text(e.subMode?.name ?? e.mode.name))),
        DataCell(Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Material(
              color: Colors.grey.withAlpha(50),
              child: dxcc != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                          child:
                              Image.asset('assets/flags/64/${dxcc.flag}.png')),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(width: 8),
            Text(
              dxcc?.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ],
        )),
        DataCell(Text(
          e.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        )),
        DataCell(Text(e.comment)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => selected?.length ?? 0;
}
