import '../models/log_entry.dart';

String generateQslCsv(List<LogEntry> logEntries, {int qsoCount = 3}) {
  final out = StringBuffer();

  // Header
  out.write('Station;Callsign;Via');
  for (int i = 1; i <= qsoCount; ++i) {
    out.write(';Q${i}Date;Q${i}Utc;Q${i}Mhz;Q${i}Mode;Q${i}Rst;Q${i}Pwr');
  }

  final data = logEntries.groupSendRcv();

  // For each station
  for (final s in data.keys) {
    // For each callsign
    for (final b in data[s]!.keys) {
      // [qsoCount] qsos at a time
      for (int c = 0; c < data[s]![b]!.length; c += qsoCount) {
        out.write('\n$s;$b;');

        final d = data[s]![b]!.skip(c).take(qsoCount);
        for (final e in d) {
          out.write(';${e.dateOnString};${e.timeOnString};${e.freqMhz};'
              '${(e.subMode ?? e.mode).name.toUpperCase()};${e.rstSent};');
          if (e.power != null) out.write('${e.power} W');
        }
        for (int i = d.length; i < qsoCount; ++i) {
          out.write(';;;;;;');
        }
      }
    }
  }

  return out.toString();
}

extension on Iterable<LogEntry> {
  Map<String?, Map<String, List<LogEntry>>> groupSendRcv() {
    final ret = <String?, Map<String, List<LogEntry>>>{};
    for (final e in this) {
      final station = e.stationCall ?? e.operatorCall;
      ret
          .putIfAbsent(station, () => {})
          .putIfAbsent(e.callsign, () => [])
          .add(e);
    }
    for (final s in ret.keys) {
      for (final b in ret[s]!.keys) {
        ret[s]![b]!.sort((a, b) => a.timeOn.compareTo(b.timeOn));
      }
    }
    return ret;
  }
}
