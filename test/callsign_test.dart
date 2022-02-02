import 'package:flutter_test/flutter_test.dart';
import 'package:ham_tools/src/utils/callsign_util.dart';

void main() {
  test('Prefix overlap', () {
    final letNum = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    final prefixes = DxccEntity.dxccs.map((e) => e.prefixRe);
    Iterable<RegExp> res;

    String f = '';
    for (final a in letNum) {
      f += a;
      res = prefixes.where((e) => f.startsWith(e));
      if (res.length > 1) {
        fail('$f :\n${res.join('\n')}');
      }

      for (final b in letNum) {
        f += b;
        res = prefixes.where((e) => f.startsWith(e));
        if (res.length > 1) {
          fail('$f :\n${res.join('\n')}');
        }

        for (final c in letNum) {
          f += c;
          res = prefixes.where((e) => f.startsWith(e));
          if (res.length > 1) {
            fail('$f :\n${res.join('\n')}');
          }

          for (final d in letNum) {
            f += d;
            res = prefixes.where((e) => f.startsWith(e));
            if (res.length > 1) {
              fail('$f :\n${res.join('\n')}');
            }

            f = f.substring(0, 3);
          }
          f = f.substring(0, 2);
        }
        f = f[0];
      }
      f = '';
    }
  });

  test('Callsign parse', () {
    // S52KJ
    // 9K/S52KJ
    // S52KJ/M
    // 9K/S52KJ/M
    // 9K/S52KJ/P/QRP
  });
}
