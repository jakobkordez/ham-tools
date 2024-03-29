import 'package:flutter_test/flutter_test.dart';
import 'package:ham_tools/src/models/callsign_data.dart';
import 'package:ham_tools/src/models/dxcc_entity.dart';

void main() {
  test('Prefix overlap', () {
    final letNum = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    // final prefixes = DxccEntity.dxccs.map((e) => e.prefixRe);
    Iterable<DxccEntity> res;
    List<String> errors = [];

    Iterable<String> genPrefixes([String prev = '', int depth = 4]) sync* {
      for (final l in letNum) {
        prev += l;
        yield prev;
        if (depth > 1) yield* genPrefixes(prev, depth - 1);
        prev = prev.substring(0, prev.length - 1);
      }
    }

    for (final p in genPrefixes()) {
      res = DxccEntity.dxccs.where((e) => p.startsWith(e.prefixRe));
      if (res.length > 1) {
        errors.add('$p :\n${res.join('\n')}');
      }
    }

    if (errors.isNotEmpty) {
      fail(errors.join('\n\n'));
    }
  });

  group('Callsign parse', () {
    test('S52KJ', () {
      final cs = CallsignData.parse('S52KJ');
      expect(cs.callsign, 'S52KJ');
      expect(cs.prefixLength, 2);
      expect(cs.prefixDxcc?.name, 'Slovenia');
      expect(cs.secPrefix, isNull);
      expect(cs.secPrefixDxcc, isNull);
      expect(cs.secSuffixes, isEmpty);
    });

    test('9K/S52KJ', () {
      final cs = CallsignData.parse('9K/S52KJ');
      expect(cs.callsign, 'S52KJ');
      expect(cs.prefixLength, 2);
      expect(cs.prefixDxcc?.name, 'Slovenia');
      expect(cs.secPrefix, '9K');
      expect(cs.secPrefixDxcc?.name, 'Kuwait');
      expect(cs.secSuffixes, isEmpty);
    });

    test('S52KJ/M', () {
      final cs = CallsignData.parse('S52KJ/M');
      expect(cs.callsign, 'S52KJ');
      expect(cs.prefixLength, 2);
      expect(cs.prefixDxcc?.name, 'Slovenia');
      expect(cs.secPrefix, isNull);
      expect(cs.secPrefixDxcc, isNull);
      expect(cs.secSuffixes, [SecondarySuffix.mobile]);
    });

    test('9K/S52KJ/M', () {
      final cs = CallsignData.parse('9K/S52KJ/M');
      expect(cs.callsign, 'S52KJ');
      expect(cs.prefixLength, 2);
      expect(cs.prefixDxcc?.name, 'Slovenia');
      expect(cs.secPrefix, '9K');
      expect(cs.secPrefixDxcc?.name, 'Kuwait');
      expect(cs.secSuffixes, [SecondarySuffix.mobile]);
    });

    test('9K/S52KJ/P/QRP', () {
      final cs = CallsignData.parse('9K/S52KJ/P/QRP');
      expect(cs.callsign, 'S52KJ');
      expect(cs.prefixLength, 2);
      expect(cs.prefixDxcc?.name, 'Slovenia');
      expect(cs.secPrefix, '9K');
      expect(cs.secPrefixDxcc?.name, 'Kuwait');
      expect(
          cs.secSuffixes, [SecondarySuffix.portable, SecondarySuffix.lowPower]);
    });

    test('9k/s52kj /p/ qrp', () {
      final cs = CallsignData.parse('9k/s52kj /p/ qrp');
      expect(cs.callsign, 'S52KJ');
      expect(cs.prefixLength, 2);
      expect(cs.prefixDxcc?.name, 'Slovenia');
      expect(cs.secPrefix, '9K');
      expect(cs.secPrefixDxcc?.name, 'Kuwait');
      expect(
          cs.secSuffixes, [SecondarySuffix.portable, SecondarySuffix.lowPower]);
    });
  });
}
