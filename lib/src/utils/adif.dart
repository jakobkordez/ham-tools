import 'dart:convert';

/// Amateur Data Interchange Format
///
/// Encode and decode LogEntries in ADIF format.
class Adif {
  const Adif._();

  static List<Map<String, String>>? tryDecodeAdi(String source) {
    final ret = <Map<String, String>>[];

    Map<String, String> vals = {};

    int i = source.indexOf('<');
    while (i != -1) {
      if (source[i] != '<') return null;
      final j = source.indexOf('>', i + 1);
      if (j == -1) return null;

      final tag = source.substring(i + 1, j);
      i = j + 1;

      if (tag == 'eoh') {
        vals = {};
      } else if (tag == 'eor') {
        ret.add(vals);
        vals = {};
      } else {
        final tagSplit = tag.split(':');
        if (tagSplit.length != 2) return null;

        final key = tagSplit.first;
        final len = int.tryParse(tagSplit.last);
        if (len == null) return null;

        String value = '';
        for (int c = 0; c < len; ++i) {
          value += source[i];
          c += utf8.encode(source[i]).length;
        }

        vals[key] = value;
      }

      i = source.indexOf('<', i);
    }

    if (vals.isNotEmpty) return null;

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
