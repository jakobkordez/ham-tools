enum CabrilloCategoryOverlay {
  // CLASSIC
  classic,
  // ROOKIE
  rookie,
  // TB-WIRES
  tbWires,
  // YOUTH
  youth,
  // NOVICE-TECH
  noviceTech,
  // OVER-50
  over50,
}

extension on CabrilloCategoryOverlay {
  String get name {
    switch (this) {
      case CabrilloCategoryOverlay.classic:
        return 'CLASSIC';
      case CabrilloCategoryOverlay.rookie:
        return 'ROOKIE';
      case CabrilloCategoryOverlay.tbWires:
        return 'TB-WIRES';
      case CabrilloCategoryOverlay.youth:
        return 'YOUTH';
      case CabrilloCategoryOverlay.noviceTech:
        return 'NOVICE-TECH';
      case CabrilloCategoryOverlay.over50:
        return 'OVER-50';
    }
  }
}
