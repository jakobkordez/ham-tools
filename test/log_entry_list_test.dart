import 'package:flutter_test/flutter_test.dart';
import 'package:ham_tools/src/models/log_entry.dart';
import 'package:ham_tools/src/utils/log_entry_list_util.dart';

void main() {
  group('insertByTime', () {
    test('Empty', () {
      final e = LogEntry(
        id: '1',
        timeOn: DateTime.now(),
        callsign: 'S52KJ',
        mode: Mode.cw,
        band: Band.hf40m,
      );
      final list = <LogEntry>[];

      list.insertByTime(e);

      expect(list, [e]);
    });

    test('Before', () {
      final e = LogEntry(
        id: '1',
        timeOn: DateTime(2022, 1, 1, 12, 1),
        callsign: 'S52KJ',
        mode: Mode.cw,
        band: Band.hf40m,
      );
      final orig = <LogEntry>[
        e.copyWith(timeOn: DateTime(2022, 1, 1, 12, 0)),
      ];
      final list = List.of(orig);

      list.insertByTime(e);

      expect(list, [e, ...orig]);
    });

    test('After', () {
      final e = LogEntry(
        id: '1',
        timeOn: DateTime(2022, 1, 1, 12, 0),
        callsign: 'S52KJ',
        mode: Mode.cw,
        band: Band.hf40m,
      );
      final orig = <LogEntry>[
        e.copyWith(timeOn: DateTime(2022, 1, 1, 12, 1)),
      ];
      final list = List.of(orig);

      list.insertByTime(e);

      expect(list, [...orig, e]);
    });

    test('Middle', () {
      final e = LogEntry(
        id: '1',
        timeOn: DateTime(2022, 1, 1, 12, 1),
        callsign: 'S52KJ',
        mode: Mode.cw,
        band: Band.hf40m,
      );
      final orig = <LogEntry>[
        e.copyWith(timeOn: DateTime(2022, 1, 1, 12, 2)),
        e.copyWith(timeOn: DateTime(2022, 1, 1, 12, 0)),
      ];
      final list = List.of(orig);

      list.insertByTime(e);

      expect(list, [orig[0], e, orig[1]]);
    });

    test('Same time on Before', () {
      final e = LogEntry(
        id: '2',
        timeOn: DateTime(2022, 1, 1, 12, 1),
        callsign: 'S52KJ',
        mode: Mode.cw,
        band: Band.hf40m,
      );
      final orig = <LogEntry>[
        e.copyWith(id: '1'),
      ];
      final list = List.of(orig);

      list.insertByTime(e);

      expect(list, [e, ...orig]);
    });

    test('Same time on After', () {
      final e = LogEntry(
        id: '1',
        timeOn: DateTime(2022, 1, 1, 12, 1),
        callsign: 'S52KJ',
        mode: Mode.cw,
        band: Band.hf40m,
      );
      final orig = <LogEntry>[
        e.copyWith(id: '2'),
      ];
      final list = List.of(orig);

      list.insertByTime(e);

      expect(list, [...orig, e]);
    });

    test('Same time on Middle', () {
      final e = LogEntry(
        id: '2',
        timeOn: DateTime(2022, 1, 1, 12, 1),
        callsign: 'S52KJ',
        mode: Mode.cw,
        band: Band.hf40m,
      );
      final orig = <LogEntry>[
        e.copyWith(id: '3'),
        e.copyWith(id: '1'),
      ];
      final list = List.of(orig);

      list.insertByTime(e);

      expect(list, [orig[0], e, orig[1]]);
    });
  });

  group('sortByTime', () {
    test('Empty', () {
      final list = <LogEntry>[];

      list.sortByTime();

      expect(list, []);
    });

    test('Single', () {
      final e = LogEntry(
        id: '1',
        timeOn: DateTime(2022, 1, 1, 12, 1),
        callsign: 'S52KJ',
        mode: Mode.cw,
        band: Band.hf40m,
      );

      final list = <LogEntry>[e];

      list.sortByTime();

      expect(list, [e]);
    });

    test('Multiple', () {
      final e = LogEntry(
        id: '1',
        timeOn: DateTime(2022, 1, 1, 12, 1),
        callsign: 'S52KJ',
        mode: Mode.cw,
        band: Band.hf40m,
      );
      final orig = <LogEntry>[
        e.copyWith(id: '2'),
        e.copyWith(id: '3'),
        e.copyWith(),
        e.copyWith(timeOn: DateTime(2022, 1, 1, 12, 0)),
        e.copyWith(timeOn: DateTime(2022, 1, 1, 12, 2)),
      ];
      final list = List.of(orig);

      list.sortByTime();
      expect(list, [orig[4], orig[1], orig[0], orig[2], orig[3]]);
    });
  });
}
