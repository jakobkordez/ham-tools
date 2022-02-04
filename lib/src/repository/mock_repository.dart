import 'dart:math';

import '../models/log_entry.dart';
import 'repository.dart';

class MockRepository implements Repository {
  final _log = List.generate(
      100,
      (i) => LogEntry(
            callsign: _genCallsign(),
            timeOn: DateTime.now().subtract(Duration(minutes: i)),
            frequency: 7005000,
            mode: Mode.cw,
            power: 100,
            rstSent: '599',
            rstRecieved: '599',
          )).toList();

  @override
  Future<List<LogEntry>> getLogEntries(
          {DateTime? after, DateTime? before}) async =>
      _log
          .where((e) =>
              (after?.isBefore(e.timeOn) ?? true) &&
              (before?.isAfter(e.timeOn) ?? true))
          .toList();

  static String _genCallsign() {
    final rnd = Random();
    String rL() => String.fromCharCode(65 + rnd.nextInt(26));
    String rN() => String.fromCharCode(48 + rnd.nextInt(10));
    String ret = '${rL()}${rN()}';
    for (int i = rnd.nextInt(3); i >= 0; --i) {
      ret += rL();
    }
    return ret;
  }
}
