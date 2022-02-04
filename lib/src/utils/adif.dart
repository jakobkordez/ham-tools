import 'dart:convert';

/// Amateur Data Interchange Format
///
/// Encode and decode LogEntries in ADIF format.
class Adif {
  const Adif._();

  static List<Map<String, String>> decodeAdi(String source) {
    final ret = <Map<String, String>>[];

    Map<String, String> vals = {};

    for (int i = source.indexOf('<'); i != -1; i = source.indexOf('<', i)) {
      final j = source.indexOf('>', i + 1);
      if (j == -1) break;

      final tag = source.substring(i + 1, j);
      i = j + 1;

      // End of header
      if (tag == 'eoh') {
        vals = {};
        continue;
      }

      // End of record
      if (tag == 'eor') {
        ret.add(vals);
        vals = {};
        continue;
      }

      final tagSplit = tag.split(':');
      if (tagSplit.length != 2) continue;

      final key = tagSplit.first;
      final len = int.tryParse(tagSplit.last);
      if (len == null) continue;

      String value = '';
      for (int c = 0; c < len; ++i) {
        value += source[i];
        c += utf8.encode(source[i]).length;
      }

      vals[key] = value;
    }

    return ret;
  }

  static String encodeAdi(List<Map<String, String>> entries,
      {bool pretty = false}) {
    final sb = StringBuffer();
    final n = pretty ? '\n' : '';

    int len(String str) => utf8.encode(str).length;

    for (final e in entries) {
      sb
        ..writeAll(
            e.entries.map((e) => '<${e.key}:${len(e.value)}>${e.value}$n'))
        ..write('<eor>$n$n');
    }

    return sb.toString();
  }
}
