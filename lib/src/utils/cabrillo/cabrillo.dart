import 'package:intl/intl.dart';

import 'cabrillo.dart';

export 'cabrillo_header.dart';
export 'qso_data.dart';

/// Cabrillo contest format
///
/// Encode QSOs in Cabrillo contest format.
///
/// https://wwrof.org/cabrillo/
class Cabrillo {
  static final dateFormat = DateFormat('yyyy-MM-dd');
  static final timeFormat = DateFormat('HHmm');

  const Cabrillo._();

  static String encodeCabrillo(
    List<CabrilloQsoData> entries, {
    CabrilloHeader? header,
  }) {
    final sb = StringBuffer();

    // HEADER
    sb.writeln('START-OF-LOG: 3.0');
    if (header != null) sb.write(header.toString());

    // QSO DATA
    final tab = List.generate(entries.length, (_) => <String>[]);
    for (var i = 0; i < entries.length; i++) {
      final e = entries[i];
      tab[i].add(e.frequency);
      tab[i].add(e.mode!);
      tab[i].add(e.date);
      tab[i].add(e.time);
      tab[i].add(e.callsignSent);
      tab[i].addAll(e.exchangeSent);
      tab[i].add(e.callsignReceived);
      tab[i].addAll(e.exchangeReceived);
      if (e.transmitterId != null) tab[i].add(e.transmitterId.toString());
    }

    const w = [5, 2, 10, 4, 13, 3, 6, 13, 3, 6];

    // TODO Size check

    const a = [1, 0, 0, 0, 0, 1, 0, 0, 1, 0];

    for (final e in tab) {
      sb.write('QSO:');
      for (int c = 0; c < e.length; ++c) {
        sb.write(' ');
        sb.write(a[c] == 0 ? e[c].padRight(w[c]) : e[c].padLeft(w[c]));
      }
      sb.writeln();
    }

    // END OF LOG
    sb.writeln('END-OF-LOG:');

    return sb.toString();
  }
}
