import 'package:flutter_test/flutter_test.dart';
import 'package:ham_tools/src/models/log_entry.dart';

void main() {
  test('Check all SubModes', () {
    final submodes = <SubMode>{};
    for (final mode in Mode.values) {
      for (final submode in mode.subModes) {
        expect(submode, isNot(isIn(submodes)));
        submodes.add(submode);
      }
    }
    expect(submodes, Set.from(SubMode.values));
  });

  test('Check Mode parsing', () {
    final modes = <Mode>{};
    for (final s in _modeStrings) {
      final m = ModeUtil.tryParse(s);
      expect(m, isNotNull);
      expect(m, isNot(isIn(modes)));
      modes.add(m!);
    }
    expect(modes, Set.from(Mode.values));
  });

  test('Check SubMode parsing', () {
    final submodes = <SubMode>{};
    for (final s in _subModeStrings) {
      final sm = SubModeUtil.tryParse(s);
      expect(sm, isNotNull, reason: 'SubModeUtil.tryParse($s)');
      expect(sm, isNot(isIn(submodes)), reason: '$s already in submodes');
      submodes.add(sm!);
    }
    expect(submodes, Set.from(SubMode.values));
  });
}

const _modeStrings = [
  'AM',
  'ARDOP',
  'ATV',
  'C4FM',
  'CHIP',
  'CLO',
  'CONTESTI',
  'CW',
  'DIGITALVOICE',
  'DOMINO',
  'DSTAR',
  'FAX',
  'FM',
  'FSK441',
  'FT8',
  'HELL',
  'ISCAT',
  'JT4',
  'JT6M',
  'JT9',
  'JT44',
  'JT65',
  'MFSK',
  'MSK144',
  'MT63',
  'OLIVIA',
  'OPERA',
  'PAC',
  'PAX',
  'PKT',
  'PSK',
  'PSK2K',
  'Q15',
  'QRA64',
  'ROS',
  'RTTY',
  'RTTYM',
  'SSB',
  'SSTV',
  'T10',
  'THOR',
  'THRB',
  'TOR',
  'V4',
  'VOI',
  'WINMOR',
  'WSPR',
];

const _subModeStrings = [
  'AMTORFEC',
  'ASCI',
  'CHIP64',
  'CHIP128',
  'DOMINOEX',
  'DOMINOF',
  'FMHELL',
  'FSK31',
  'FSKHELL',
  'FSQCALL',
  'FT4',
  'GTOR',
  'HELL80',
  'HFSK',
  'ISCAT-A',
  'ISCAT-B',
  'JS8',
  'JT4A',
  'JT4B',
  'JT4C',
  'JT4D',
  'JT4E',
  'JT4F',
  'JT4G',
  'JT9-1',
  'JT9-2',
  'JT9-5',
  'JT9-10',
  'JT9-30',
  'JT9A',
  'JT9B',
  'JT9C',
  'JT9D',
  'JT9E',
  'JT9E FAST',
  'JT9F',
  'JT9F FAST',
  'JT9G',
  'JT9G FAST',
  'JT9H',
  'JT9H FAST',
  'JT65A',
  'JT65B',
  'JT65B2',
  'JT65C',
  'JT65C2',
  'LSB',
  'MFSK4',
  'MFSK8',
  'MFSK11',
  'MFSK16',
  'MFSK22',
  'MFSK31',
  'MFSK32',
  'MFSK64',
  'MFSK128',
  'OLIVIA 4/125',
  'OLIVIA 4/250',
  'OLIVIA 8/250',
  'OLIVIA 8/500',
  'OLIVIA 16/500',
  'OLIVIA 16/1000',
  'OLIVIA 32/1000',
  'OPERA-BEACON',
  'OPERA-QSO',
  'PAC2',
  'PAC3',
  'PAC4',
  'PAX2',
  'PCW',
  'PSK10',
  'PSK31',
  'PSK63',
  'PSK63F',
  'PSK125',
  'PSK250',
  'PSK500',
  'PSK1000',
  'PSKAM10',
  'PSKAM31',
  'PSKAM50',
  'PSKFEC31',
  'PSKHELL',
  'QPSK31',
  'QPSK63',
  'QPSK125',
  'QPSK250',
  'QPSK500',
  'QRA64A',
  'QRA64B',
  'QRA64C',
  'QRA64D',
  'QRA64E',
  'ROS-EME',
  'ROS-HF',
  'ROS-MF',
  'SIM31',
  'THRBX',
  'USB',
];
