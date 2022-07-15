enum CabrilloCategoryMode {
  // CW
  cw,
  // DIGI
  digi,
  // FM
  fm,
  // RTTY
  rtty,
  // SSB
  ssb,
  // MIXED
  mixed,
}

extension on CabrilloCategoryMode {
  String get name {
    switch (this) {
      case CabrilloCategoryMode.cw:
        return 'CW';
      case CabrilloCategoryMode.digi:
        return 'DIGI';
      case CabrilloCategoryMode.fm:
        return 'FM';
      case CabrilloCategoryMode.rtty:
        return 'RTTY';
      case CabrilloCategoryMode.ssb:
        return 'SSB';
      case CabrilloCategoryMode.mixed:
        return 'MIXED';
    }
  }
}
