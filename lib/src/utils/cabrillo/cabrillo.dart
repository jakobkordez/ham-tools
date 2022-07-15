import 'package:ham_tools/src/utils/cabrillo/qso_data.dart';
import 'package:intl/intl.dart';

import 'cabrillo_header.dart';

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
    sb.write(header.toString());

    // QSO DATA
    final tab = [for (final e in entries) <String>[]];

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
