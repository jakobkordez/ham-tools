part of 'log_entry.dart';

enum Mode { cw, ssb, am, fm, digi }

extension ModeUtil on Mode {
  static Mode? tryParse(String? value) {
    if (value == null) return null;
    value = value.toLowerCase();
    return Mode.values.firstWhereOrNull((m) => m.name == value);
  }
}
