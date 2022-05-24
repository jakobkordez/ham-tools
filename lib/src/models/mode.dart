part of 'log_entry.dart';

enum Mode {
  am,
  ardop,
  atv,
  c4fm,
  chip,
  clo,
  contesti,
  cw,
  digitalvoice,
  domino,
  dstar,
  fax,
  fm,
  fsk441,
  ft8,
  hell,
  iscat,
  jt4,
  jt6m,
  jt9,
  jt44,
  jt65,
  mfsk,
  msk144,
  mt63,
  olivia,
  opera,
  pac,
  pax,
  pkt,
  psk,
  psk2k,
  q15,
  qra64,
  ros,
  rtty,
  rttym,
  ssb,
  sstv,
  t10,
  thor,
  thrb,
  tor,
  v4,
  voi,
  winmor,
  wspr,
}

extension ModeUtil on Mode {
  static Mode? tryParse(String? value) {
    if (value == null) return null;
    value = value.toLowerCase();
    return Mode.values.firstWhereOrNull((m) => m.name == value);
  }

  static List<Mode> get topModes =>
      [Mode.cw, Mode.ssb, Mode.am, Mode.fm, Mode.rtty, Mode.ft8];

  String? get defaultReport {
    switch (this) {
      case Mode.cw:
      case Mode.rtty:
        return '599';
      case Mode.ssb:
      case Mode.am:
      case Mode.fm:
        return '59';
      default:
        return null;
    }
  }
}
