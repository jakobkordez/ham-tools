enum CabrilloCategoryPower {
  // HIGH
  high,
  // LOW
  low,
  // QRP
  qrp,
}

extension on CabrilloCategoryPower {
  String get name {
    switch (this) {
      case CabrilloCategoryPower.high:
        return 'HIGH';
      case CabrilloCategoryPower.low:
        return 'LOW';
      case CabrilloCategoryPower.qrp:
        return 'QRP';
    }
  }
}
