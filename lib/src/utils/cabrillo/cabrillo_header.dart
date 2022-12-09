import 'dart:math';

import 'categories/band.dart';
import 'categories/mode.dart';
import 'categories/operator.dart';
import 'categories/power.dart';
import 'categories/station.dart';
import 'categories/time.dart';
import 'categories/transmitter.dart';
import 'categories/overlay.dart';

export 'categories/band.dart';
export 'categories/mode.dart';
export 'categories/operator.dart';
export 'categories/power.dart';
export 'categories/station.dart';
export 'categories/time.dart';
export 'categories/transmitter.dart';
export 'categories/overlay.dart';

class CabrilloHeader {
  static const maxContestLength = 32;
  static const maxNameLength = 75;
  static const maxAddressLineLen = 45;
  static const maxAddressLines = 6;
  static const maxOperatorsLineLen = 75;
  static const maxSoapboxLineLen = 75;
  final offtimePattern =
      RegExp(r'^\d{4}-\d{2}-\d{2} \d{4} \d{4}-\d{2}-\d{2} \d{4}$');

  /// The callsign used during the contest.
  String? callsign;

  /// String to identify the contest.
  /// Valid characters are A-Z, 0-9, and hyphen (-).
  /// Maximum length is 32 characters.
  String? contest;

  bool? assisted;
  CabrilloCategoryBand? band;
  CabrilloCategoryMode? mode;
  CabrilloCategoryOperator? operator;
  CabrilloCategoryPower? power;

  /// Type of station
  CabrilloCategoryStation? station;
  CabrilloCategoryTime? time;

  /// The category-transmitter is required for multi-operator entries
  CabrilloCategoryTransmitter? transmitter;
  CabrilloCategoryOverlay? overlay;

  /// Indicate if you wish to receive, if eligible, a paper certificate
  /// sent via postal mail by the contest sponsor.
  /// The contest sponsor may or may not honor this tag,
  /// and if so may or may not use opt-in or opt-out as the default.
  /// YES is the default.
  bool certificate = true;

  /// The claimed-score of the log submission.
  int? claimedScore;

  /// Name of the radio club to which the score should be applied.
  String? club;

  /// Name and version of the logging program used to create the Cabrillo file.
  String createdBy = 'HAM Tools by S52KJ';

  /// Contact email address for the entrant. Must be valid email or blank.
  String email = '';

  /// Used to indicate the Maidenhead Grid Square where the station
  /// was operating from.
  /// E.g., FN42, JO44EB
  String? gridLocator;

  /// Used to indicate the location where the station was operating from.
  ///
  /// [ARRL/RAC Sections](http://www.arrl.org/section-abbreviations) -
  /// For USA and Canada stations LOCATION must be the ARRL section abbreviation.
  /// For foreign stations LOCATION must be ‘DX’. This information is required
  /// for IARU-HF and for all ARRL and CQ contests.
  ///
  /// [IOTA Island Name](http://www.rsgbiota.org) -
  /// This information is required for RSGB-IOTA contest and
  /// includes Island Name (not IOTA reference number).
  ///
  /// [RDA Number](http://rdaward.org/rda_eng.txt) -
  /// This information is required for RDXC contest.
  String? location;

  /// Name. Maximum of 75 characters long.
  String? name;

  /// Mailing address. Each line should be a maximum of 45 characters long.
  /// Up to 6 address lines are permitted.
  String? address;
  String? addressCity;
  String? addressStateProvince;
  String? addressPostalCode;
  String? addressCountry;

  /// List of operator callsign(s).
  /// You may also list the callsign of the host station by placing an “@”
  /// character in front of the callsign within the operator list.
  List<String>? operators;

  /// Off-times
  ///
  /// ```
  /// yyyy-mm-dd nnnn yyyy-mm-dd nnnn
  /// -----begin----- ------end------
  /// ```
  List<String>? offTimes;

  /// Soapbox comments. Enter as many lines of soapbox text as you wish.
  String soapBox = '';

  @override
  String toString() {
    final sb = StringBuffer();

    void wrln(String name, String? value) {
      if (value != null) sb.writeln('$name: $value');
    }

    wrln('CALLSIGN', callsign);

    if (contest != null) {
      if (contest!.length > maxContestLength) {
        print('WARN: Contest name too long');
      }
      if (contest!.contains(RegExp(r'[^A-Z0-9-]'))) {
        print('WARN: Contest name contains invalid characters');
      }
    }
    wrln('CONTEST', contest);

    if (assisted != null) {
      sb.writeln('CATEGORY-ASSISTED: ${assisted! ? '' : 'NON-'}ASSISTED');
    }
    wrln('CATEGORY-BAND', band?.name);
    wrln('CATEGORY-MODE', mode?.name);
    wrln('CATEGORY-OPERATOR', operator?.name);
    wrln('CATEGORY-POWER', power?.name);
    wrln('CATEGORY-STATION', station?.name);
    wrln('CATEGORY-TIME', time?.name);
    wrln('CATEGORY-TRANSMITTER', transmitter?.name);
    wrln('CATEGORY-OVERLAY', overlay?.name);

    wrln('CERTIFICATE', certificate ? 'YES' : 'NO');
    wrln('CLAIMED-SCORE', claimedScore?.abs().toString());

    wrln('CLUB', club);
    wrln('CREATED-BY', createdBy);
    wrln('EMAIL', email);
    wrln('GRID-LOCATOR', gridLocator);
    wrln('LOCATION', location);

    wrln('NAME', name?.substring(0, min(maxNameLength, name!.length)));

    if (address != null) {
      const addressMaxLen = maxAddressLineLen - 'ADDRESS: '.length;
      final addr = address!
          .split(RegExp(r'[\n\r]+'))
          .map((e) => e.substring(0, min(addressMaxLen, e.length)))
          .take(maxAddressLines);
      for (final a in addr) {
        wrln('ADDRESS', a);
      }
    }
    wrln('ADDRESS-CITY', addressCity);
    wrln('ADDRESS-STATE-PROVINCE', addressStateProvince);
    wrln('ADDRESS-POSTAL-CODE', addressPostalCode);
    wrln('ADDRESS-COUNTRY', addressCountry);

    // The OPERATOR line is a maximum of 75 characters long and must begin
    // with OPERATORS: followed by a space.
    // Use multiple OPERATOR lines if needed.
    if (operators != null && operators!.isNotEmpty) {
      String line = 'OPERATORS:';
      for (final op in operators!) {
        if (line.length + op.length + 1 > maxOperatorsLineLen) {
          sb.writeln(line);
          line = 'OPERATORS:';
        }
        line += ' $op';
      }
      sb.writeln(line);
    }

    for (final ot in offTimes ?? <String>[]) {
      wrln('OFFTIME', ot);
    }

    // Each line is a maximum of 75 characters long and must begin with
    // SOAPBOX: followed by a space.
    const soapboxMaxLen = maxSoapboxLineLen - 'SOAPBOX: '.length;
    final sbox = soapBox
        .split(RegExp(r'[\n\r]'))
        .map((e) => e.substring(0, min(soapboxMaxLen, e.length)));
    for (final s in sbox) {
      wrln('SOAPBOX', s);
    }

    return sb.toString();
  }
}
