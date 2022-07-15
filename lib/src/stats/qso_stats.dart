import 'package:equatable/equatable.dart';

import '../models/log_entry.dart';
import '../utils/adif.dart';

class QsoStats extends Equatable {
  final Map<String, int> mode;
  final Map<String, int> band;

  QsoStats._({
    required Map<String, int> band,
    required Map<String, int> mode,
  })  : band = Map.fromEntries(band.entries.toList()
          ..sort((a, b) => Band.values
              .indexOf(BandUtil.tryParse(a.key)!)
              .compareTo(Band.values.indexOf(BandUtil.tryParse(b.key)!)))),
        mode = Map.fromEntries(
            mode.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));

  factory QsoStats.parse(String adif) {
    final mode = <String, int>{};
    final band = <String, int>{};

    for (var e in Adif.decodeAdi(adif)) {
      e = e.map((key, value) => MapEntry(key.toLowerCase(), value));
      if (e.containsKey('mode')) {
        mode.update(e['mode']!, (v) => v + 1, ifAbsent: () => 1);
      }
      if (e.containsKey('band')) {
        band.update(e['band']!, (v) => v + 1, ifAbsent: () => 1);
      }
    }

    return QsoStats._(mode: mode, band: band);
  }

  factory QsoStats.fromLogEntries(List<LogEntry> log) {
    final mode = <String, int>{};
    final band = <String, int>{};

    for (var e in log) {
      mode.update(e.mode.name, (v) => v + 1, ifAbsent: () => 1);
      band.update(e.band?.name ?? '?', (v) => v + 1, ifAbsent: () => 1);
    }

    return QsoStats._(mode: mode, band: band);
  }

  @override
  List<Object?> get props => [mode, band];
}
