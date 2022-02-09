part of 'log_entry.dart';

enum Mode { cw, ssb, am, fm }

extension ModeUtil on Mode {
  static Mode? tryParse(String? value) {
    if (value == null) return null;
    value = value.toLowerCase();
    return Mode.values.firstWhereOrNull((m) => m.name == value);
  }

  String? get defaultReport {
    switch (this) {
      case Mode.cw:
        return '599';
      case Mode.ssb:
      case Mode.am:
      case Mode.fm:
        return '59';
    }
  }
}
