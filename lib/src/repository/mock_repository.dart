import 'dart:math';

import 'package:ham_tools/src/models/log_entry.dart';

import 'repository.dart';

class MockRepository implements Repository {
  final _log = List.generate(
      100,
      (i) => LogEntry(
            id: i + 1,
            callsign: _genCallsign(),
            time: DateTime.now(),
            frequency: 7005000,
            mode: Mode.cw,
            power: 100,
            qth: '',
            rstS: '599',
            rstR: '599',
          )).reversed.toList();

  @override
  Future<List<LogEntry>> getLogEntries({int count = 30, int? skipId}) async =>
      _log
          .skipWhile((e) => skipId != null && e.id >= skipId)
          .take(count)
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
