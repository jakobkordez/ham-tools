enum CabrilloCategoryStation {
  // DISTRIBUTED
  distributed,
  // FIXED
  fixed,
  // MOBILE
  mobile,
  // PORTABLE
  portable,
  // ROVER
  rover,
  // ROVER-LIMITED
  roverLimited,
  // ROVER-UNLIMITED
  roverUnlimited,
  // EXPEDITION
  expedition,
  // HQ
  hq,
  // SCHOOL
  school,
  // EXPLORER
  explorer,
}

extension on CabrilloCategoryStation {
  String get name {
    switch (this) {
      case CabrilloCategoryStation.distributed:
        return 'DISTRIBUTED';
      case CabrilloCategoryStation.fixed:
        return 'FIXED';
      case CabrilloCategoryStation.mobile:
        return 'MOBILE';
      case CabrilloCategoryStation.portable:
        return 'PORTABLE';
      case CabrilloCategoryStation.rover:
        return 'ROVER';
      case CabrilloCategoryStation.roverLimited:
        return 'ROVER-LIMITED';
      case CabrilloCategoryStation.roverUnlimited:
        return 'ROVER-UNLIMITED';
      case CabrilloCategoryStation.expedition:
        return 'EXPEDITION';
      case CabrilloCategoryStation.hq:
        return 'HQ';
      case CabrilloCategoryStation.school:
        return 'SCHOOL';
      case CabrilloCategoryStation.explorer:
        return 'EXPLORER';
    }
  }
}
