enum CabrilloCategoryTransmitter {
  // ONE
  one,
  // TWO
  two,
  // LIMITED
  limited,
  // UNLIMITED
  unlimited,
  // SWL
  swl,
}

extension on CabrilloCategoryTransmitter {
  String get name {
    switch (this) {
      case CabrilloCategoryTransmitter.one:
        return 'ONE';
      case CabrilloCategoryTransmitter.two:
        return 'TWO';
      case CabrilloCategoryTransmitter.limited:
        return 'LIMITED';
      case CabrilloCategoryTransmitter.unlimited:
        return 'UNLIMITED';
      case CabrilloCategoryTransmitter.swl:
        return 'SWL';
    }
  }
}
