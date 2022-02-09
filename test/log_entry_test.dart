import 'package:flutter_test/flutter_test.dart';
import 'package:ham_tools/src/models/log_entry.dart';

void main() {
  group('fromAdiMap', () {
    test('minimum with freq', () {
      final entry = LogEntry.fromAdiMap(const {
        'CALL': 'S52KJ',
        'FREQ': '14.1234',
        'QSO_DATE': '20220208',
        'TIME_ON': '1245',
        'MODE': 'SSB',
      });

      expect(entry.callsign, 'S52KJ');
      expect(entry.frequency, 14123400);
      expect(entry.band, Band.hf20m);
      expect(entry.timeOn, DateTime.utc(2022, 2, 8, 12, 45));
      expect(entry.timeOff, DateTime.utc(2022, 2, 8, 12, 45));
      expect(entry.mode, Mode.ssb);
    });

    test('minimum with band', () {
      final entry = LogEntry.fromAdiMap(const {
        'CALL': 's52kj',
        'BAND': '20M',
        'QSO_DATE': '20220208',
        'TIME_ON': '1245',
        'MODE': 'ssb',
      });

      expect(entry.callsign, 'S52KJ');
      expect(entry.frequency, Band.hf20m.lowerBound);
      expect(entry.band, Band.hf20m);
      expect(entry.timeOn, DateTime.utc(2022, 2, 8, 12, 45));
      expect(entry.timeOff, DateTime.utc(2022, 2, 8, 12, 45));
      expect(entry.mode, Mode.ssb);
    });
  });
}
