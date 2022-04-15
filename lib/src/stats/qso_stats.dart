import 'package:equatable/equatable.dart';

import '../utils/adif.dart';

class QsoStats extends Equatable {
  final Map<String, int> mode;
  final Map<String, int> band;

  const QsoStats._({
    required this.mode,
    required this.band,
  });

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

  @override
  List<Object?> get props => [mode, band];
}
