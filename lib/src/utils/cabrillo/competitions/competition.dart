import '../cabrillo.dart';

abstract class Competition {
  String get name;
  String get id;
  List<CabrilloCategoryBand>? get bandCategories;
  List<CabrilloCategoryMode>? get modeCategories;
  List<CabrilloCategoryPower>? get powerCategories;
  List<CabrilloCategoryStation>? get stationCategories;
  List<CabrilloCategoryTime>? get timeCategories;
  List<CabrilloCategoryTransmitter>? get transmitterCategories;
  List<CabrilloCategoryOverlay>? get overlayCategories;
}
