// ignore_for_file: avoid_print

import 'dart:io';

import 'package:ham_tools/src/models/log_entry.dart';
import 'package:ham_tools/src/utils/adif.dart';

const qsoCount = 3;

void main(List<String> args) {
  if (args.length != 2) {
    print('Usage: adi_qsl_csv.dart <input> <output>');
    return;
  }

  print('Reading: ${args.first}');
  final ent = Adif.decodeAdi(File(args.first).readAsStringSync())
      .map((e) => LogEntry.fromAdiMap(e))
      .toList();
  print(
      '${ent.length} QSO\'s, ${Set.of(ent.map((e) => e.callsign)).length} unique callsigns');
  stdout.write('Callsigns (seperated with ,): ');
  final calls = stdin.readLineSync()!.split(',');
  final filtered = ent.where((e) => calls.contains(e.callsign)).toList();
  print('Found ${filtered.length} entries');

  // Header
  String out = 'Station;Callsign;Via';
  for (int i = 1; i <= qsoCount; ++i) {
    out += ';Q${i}Date;Q${i}Utc;Q${i}Mhz;Q${i}Mode;Q${i}Rst;Q${i}Pwr';
  }

  final data = filtered.groupSendRcv();

  // For each station
  for (final s in data.keys) {
    // For each callsign
    for (final b in data[s]!.keys) {
      // [qsoCount] qsos at a time
      for (int c = 0; c < data[s]![b]!.length; c += qsoCount) {
        out += '\n$s;$b;';

        final d = data[s]![b]!.skip(c).take(qsoCount);
        for (final e in d) {
          out += ';${e.dateOnString};${e.timeOnString};${e.freqMhz};'
              '${(e.subMode ?? e.mode).name.toUpperCase()};${e.rstSent};';
          if (e.power != null) out += '${e.power} W';
        }
        for (int i = d.length; i < qsoCount; ++i) {
          out += ';;;;;;';
        }
      }
    }
  }

  print('\n$out\n');
  File(args.last).writeAsStringSync(out);
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
