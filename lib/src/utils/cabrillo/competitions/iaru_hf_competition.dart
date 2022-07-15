import '../cabrillo.dart';
import 'competition.dart';

class IaruHfCompetition implements Competition {
  @override
  String get name => 'IARU HF World Championship';

  @override
  String get id => 'IARU-HF';

  @override
  List<CabrilloCategoryBand>? get bandCategories => null;

  @override
  List<CabrilloCategoryMode>? get modeCategories => [
        CabrilloCategoryMode.cw,
        CabrilloCategoryMode.ssb,
        CabrilloCategoryMode.mixed,
      ];

  @override
  List<CabrilloCategoryOverlay>? get overlayCategories => [
        CabrilloCategoryOverlay.classic,
        CabrilloCategoryOverlay.youth,
      ];

  @override
  List<CabrilloCategoryPower>? get powerCategories => [
        CabrilloCategoryPower.qrp,
        CabrilloCategoryPower.low,
        CabrilloCategoryPower.high,
      ];

  @override
  List<CabrilloCategoryStation>? get stationCategories => [
        CabrilloCategoryStation.fixed,
        CabrilloCategoryStation.hq,
      ];

  @override
  List<CabrilloCategoryTime>? get timeCategories => null;

  @override
  List<CabrilloCategoryTransmitter>? get transmitterCategories => [
        CabrilloCategoryTransmitter.one,
        CabrilloCategoryTransmitter.unlimited,
      ];
}
