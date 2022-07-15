enum CabrilloCategoryTime {
  // 6-HOURS
  sixHours,
  // 8-HOURS
  eightHours,
  // 12-HOURS
  twelveHours,
  // 24-HOURS
  twentyFourHours,
}

extension on CabrilloCategoryTime {
  String get name {
    switch (this) {
      case CabrilloCategoryTime.sixHours:
        return '6-HOURS';
      case CabrilloCategoryTime.eightHours:
        return '8-HOURS';
      case CabrilloCategoryTime.twelveHours:
        return '12-HOURS';
      case CabrilloCategoryTime.twentyFourHours:
        return '24-HOURS';
    }
  }
}
