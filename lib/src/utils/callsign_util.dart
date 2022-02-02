import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class CallsignData {
  final String callsign;
  final int? prefixLength;
  final String? secPrefix;
  final List<String> secSuffixes;
  final DxccEntity? prefixDxcc;
  final DxccEntity? secPrefixDxcc;

  CallsignData._({
    required this.callsign,
    this.prefixLength,
    this.secPrefix,
    this.secSuffixes = const [],
    this.prefixDxcc,
    this.secPrefixDxcc,
  });

  factory CallsignData.parse(String callsign) {
    callsign = callsign.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9\/]+'), '');
    final regMatch = RegExp(
            r'^([A-Z\d]{1,3}\/)?([A-Z\d]{1,3}\d[A-Z][A-Z\d]*)((\/[A-Z\d]+)*)$')
        .firstMatch(callsign);

    if (regMatch == null) return CallsignData._(callsign: callsign);

    String? t = regMatch.group(1);
    final secPrefix = t?.substring(0, t.length - 1);

    t = regMatch.group(2)!;
    final dxcc = DxccEntity.findSub(t);
    final prefixLength = dxcc?.prefixRe.matchAsPrefix(t)?.end;

    return CallsignData._(
      callsign: t,
      prefixLength: prefixLength,
      prefixDxcc: dxcc,
      secPrefixDxcc: secPrefix != null ? DxccEntity.findSub(secPrefix) : null,
      secPrefix: secPrefix,
      secSuffixes: List.unmodifiable(regMatch.group(3)!.split('/').skip(1)),
    );
  }
}

enum Continent {
  europe,
  asia,
  africa,
  southAmerica,
  northAmerica,
  oceania,
  antartica,
}

class DxccEntity extends Equatable {
  final String name;
  final int dxcc;
  final Continent continent;
  final int timezoneOffset;
  final int ituZone;
  final int cqZone;
  final String flag;
  final String prefix;
  final List<DxccEntity> sub;

  const DxccEntity._(
    this.name,
    this.dxcc,
    this.continent,
    this.timezoneOffset,
    this.ituZone,
    this.cqZone,
    this.flag,
    this.prefix, [
    this.sub = const [],
  ]);

  RegExp get prefixRe => RegExp('^$prefix', caseSensitive: false);

  static DxccEntity? find(String callsign) =>
      dxccs.firstWhereOrNull((e) => callsign.startsWith(e.prefixRe));

  static DxccEntity? findSub(String callsign, [DxccEntity? p]) {
    final dxcc = (p?.sub ?? dxccs)
        .firstWhereOrNull((e) => callsign.startsWith(e.prefixRe));
    if (dxcc == null) return p;

    return findSub(callsign, dxcc);
  }

  @override
  List<Object?> get props => [
        name,
        dxcc,
        continent,
        timezoneOffset,
        ituZone,
        cqZone,
        flag,
        prefix,
        sub,
      ];

  static const dxccs = <DxccEntity>[
    DxccEntity._('Afghanistan', 3, Continent.asia, 5, 40, 21, 'AF', 'T6|YA'),
    DxccEntity._('Albania', 7, Continent.europe, 1, 28, 15, 'AL', 'ZA'),
    DxccEntity._('Algeria', 400, Continent.africa, 0, 37, 33, 'DZ', '7[RT-Y]'),
    DxccEntity._('Andorra', 203, Continent.europe, 1, 27, 14, 'AD', 'C3'),
    DxccEntity._('Angola', 401, Continent.africa, 1, 52, 36, 'AO', 'D[23]'),
    // Abc('Antarctica', 13, Continent.Antartica, 0, 67, 12, 'AQ'),
    DxccEntity._('Antigua and Barbuda', 94, Continent.northAmerica, -4, 11, 8,
        'AG', 'V2'),
    DxccEntity._('Argentina', 100, Continent.southAmerica, -3, 14, 13, 'AR',
        'A[YZ]|L[2-9O-W]'),
    DxccEntity._('Armenia', 14, Continent.asia, 4, 29, 21, 'AM', 'EK'),
    DxccEntity._(
        'Australia', 150, Continent.oceania, 10, 55, 29, 'AU', 'AX|V[H-NZ]', [
      DxccEntity._('Christmas Island', 35, Continent.oceania, 7, 54, 29, 'CX',
          r'VK9(.*\/X|[KNZ]?X)'),
      DxccEntity._('Cocos-Keeling Islands', 38, Continent.oceania, 7, 54, 29,
          'CC', r'VK9(.*\/Y|[KNZ]?C)'),
      DxccEntity._(
          'Heard Islands', 111, Continent.africa, 5, 68, 39, 'AU', r'VK0.*\/H'),
      DxccEntity._('Lord Howe Island', 147, Continent.oceania, 10, 60, 30, 'AU',
          r'VK9(.*\/H|[KNZ]?L)'),
      DxccEntity._('Macquarie Island', 153, Continent.oceania, 11, 60, 30, 'AU',
          r'VK0.*\/M'),
      DxccEntity._('Mellish Reef', 171, Continent.oceania, 10, 55, 30, 'AU',
          r'VK9(.*\/Z|[KNZ]?M)'),
      DxccEntity._('Norfolk Island', 189, Continent.oceania, 12, 60, 32, 'NF',
          r'VK9(.*\/N|[KNZ]?N)'),
      DxccEntity._('Willis Island', 303, Continent.oceania, 10, 55, 30, 'AU',
          r'VK9(.*\/W|[KNZ]?W)'),
    ]),
    // Notes: Australia covers CQ zones 29 and 30. It also has ITU zones 55, 58 and 59.
    DxccEntity._('Austria', 206, Continent.europe, 1, 28, 15, 'AT', 'OE'),
    DxccEntity._('Azerbaijan', 18, Continent.asia, 4, 29, 21, 'AZ', '4[JK]'),
    DxccEntity._('Bahamas', 60, Continent.northAmerica, -5, 11, 8, 'BS', 'C6'),
    DxccEntity._('Bahrain', 304, Continent.asia, 4, 39, 21, 'BH', 'A9'),
    DxccEntity._('Bangladesh', 305, Continent.asia, 6, 41, 22, 'BD', 'S[23]'),
    DxccEntity._('Barbados', 62, Continent.northAmerica, -4, 11, 8, 'BB', '8P'),
    DxccEntity._('Belarus', 27, Continent.europe, 2, 29, 16, 'BY', 'E[U-W]'),
    DxccEntity._('Belgium', 209, Continent.europe, 1, 27, 14, 'BE', 'O[N-T]'),
    DxccEntity._('Belize', 66, Continent.northAmerica, -6, 11, 7, 'BZ', 'V3'),
    DxccEntity._('Benin', 416, Continent.africa, 0, 46, 35, 'BJ', 'TY'),
    DxccEntity._('Bhutan', 306, Continent.asia, 6, 41, 22, 'BT', 'A5'),
    DxccEntity._(
        'Bolivia', 104, Continent.southAmerica, -4, 12, 10, 'BO', 'CP'),
    DxccEntity._('Bosnia and Herzegovina', 501, Continent.europe, 1, 28, 15,
        'BA', 'E7|T9'),
    DxccEntity._('Botswana', 402, Continent.africa, 2, 57, 38, 'BW', '8O|A2'),
    DxccEntity._('Brazil', 108, Continent.southAmerica, -3, 12, 11, 'BR',
        'P[P-Y]|Z[V-Z]', [
      DxccEntity._('Fernando de Noronha', 56, Continent.southAmerica, -2, 13,
          11, 'BR', r'Z[XYZ]0F|P[QUXY]0F|PY0.*\/F'),
      DxccEntity._('St Peter & St Paul Rocks', 253, Continent.southAmerica, -2,
          13, 11, 'BR', r'Z[XYZ]0S|P[QUXY]0S|PY0.*\/S'),
      DxccEntity._(
          'Trindade and Martim Vaz Island',
          273,
          Continent.southAmerica,
          -2,
          15,
          11,
          'BR',
          r'Z[XYZ]0T|P[QUXY]0T|PY0.*\/T'),
    ]),
    DxccEntity._('Brunei', 345, Continent.oceania, 8, 54, 28, 'BN', 'V8'),
    DxccEntity._('Bulgaria', 212, Continent.europe, 2, 28, 20, 'BG', 'LZ'),
    DxccEntity._('Burkina Faso', 480, Continent.africa, 0, 46, 35, 'BF', 'XT'),
    DxccEntity._('Burundi', 404, Continent.africa, 3, 52, 36, 'BI', '9U'),
    DxccEntity._('Cambodia', 312, Continent.asia, 8, 49, 26, 'KH', 'XU'),
    DxccEntity._('Cameroon', 406, Continent.africa, 1, 47, 36, 'CM', 'TJ'),
    DxccEntity._('Canada', 1, Continent.northAmerica, -5, 2, 1, 'CA',
        'C[F-KYZ]|V[A-GOXY]|X[J-O]', [
      DxccEntity._(
          'Sable Island', 211, Continent.northAmerica, -5, 9, 5, 'CA', 'CY0'),
      DxccEntity._(
          'St Paul Island', 252, Continent.northAmerica, -5, 9, 5, 'CA', 'CY9'),
    ]),
    DxccEntity._('Cape Verde', 409, Continent.africa, -2, 46, 35, 'CV', 'D4'),
    DxccEntity._('Central African Republic', 408, Continent.africa, 1, 47, 36,
        'CF', 'TL'),
    DxccEntity._('Chad', 410, Continent.africa, 1, 47, 36, 'TD', 'TT'),
    DxccEntity._('Chile', 112, Continent.southAmerica, -4, 14, 12, 'CL',
        '3G|C[A-E]|X[QR]', [
      DxccEntity._('Easter Island', 47, Continent.southAmerica, -7, 63, 12,
          'CL', 'CE0[AEFY]|XQ0Y|XR0[YZ]'),
      DxccEntity._('Juan Fernandez Islands', 125, Continent.southAmerica, -4,
          14, 12, 'CL', 'CE0[IZ]|XQ0Z'),
      DxccEntity._('San Felix', 217, Continent.southAmerica, -5, 14, 12, 'CL',
          '(CE|XQ)0X'),
    ]),
    DxccEntity._('China', 318, Continent.asia, 8, 33, 23, 'CN',
        '3[H-U]|B[A-Z]|XS|VR|XX', [
      DxccEntity._(
          'Hong Kong', 321, Continent.asia, 8, 44, 24, 'HK', 'VR2|VS6'),
      DxccEntity._('Macau', 152, Continent.asia, 8, 44, 24, 'MO', 'XX'),
      DxccEntity._(
          'Scarborough Reef', 506, Continent.asia, 8, 50, 27, 'CN', 'BS7'),
      DxccEntity._(
          'Taiwan', 386, Continent.asia, 8, 44, 24, 'TW', 'B[M-QU-X]', [
        DxccEntity._(
            'Pratas Island', 505, Continent.asia, 8, 44, 24, 'TW', 'BV9P'),
      ]),
    ]),
    DxccEntity._(
        'Colombia', 116, Continent.southAmerica, -5, 12, 9, 'CO', '[5H][JK]', [
      DxccEntity._('Malpelo Island', 161, Continent.southAmerica, -5, 12, 9,
          'CO', r'HK0(.*\/)?M'),
      DxccEntity._('San Andres and Providencia', 216, Continent.northAmerica,
          -6, 11, 7, 'CO', r'HK0(.*\/)?S'),
    ]),
    DxccEntity._('Comoros', 411, Continent.africa, 3, 53, 39, 'KM', 'D6'),
    DxccEntity._('Congo', 412, Continent.africa, 1, 52, 36, 'CG', 'TN'),
    DxccEntity._('Democratic Republic of the Congo', 414, Continent.africa, 1,
        52, 36, 'CD', '9[O-T]'),
    DxccEntity._(
        'Costa Rica', 308, Continent.northAmerica, -6, 11, 7, 'CR', 'T[EI]', [
      DxccEntity._(
          'Cocos Island', 37, Continent.northAmerica, -6, 11, 7, 'CR', 'TI9'),
    ]),
    DxccEntity._('Croatia', 497, Continent.europe, 1, 28, 15, 'HR', '9A'),
    DxccEntity._(
        'Cuba', 70, Continent.northAmerica, -5, 11, 8, 'CU', 'C[LMO]|T4'),
    DxccEntity._('Cyprus', 215, Continent.asia, 3, 39, 20, 'CY', '5B|C4|H2|P3'),
    DxccEntity._(
        'Czech Republic', 503, Continent.europe, 1, 28, 15, 'CZ', 'O[KL]'),
    DxccEntity._(
        'Denmark', 221, Continent.europe, 1, 18, 14, 'DK', '5[PQ]|O[U-Z]|XP', [
      DxccEntity._(
          'Faroe Islands', 222, Continent.europe, 0, 18, 14, 'FO', 'OY'),
      DxccEntity._(
          'Greenland', 237, Continent.northAmerica, -3, 5, 40, 'GL', 'OX'),
    ]),
    DxccEntity._('Djibouti', 382, Continent.africa, 3, 48, 37, 'DJ', 'J2'),
    DxccEntity._('Dominica', 95, Continent.northAmerica, -4, 11, 8, 'DM', 'J7'),
    DxccEntity._('Dominican Republic', 72, Continent.northAmerica, -4, 11, 8,
        'DO', 'HI'),
    // Abc('Ducie Island', 513, Continent.Oceania, -9, 63, 32, 'PN'),
    DxccEntity._(
        'Ecuador', 120, Continent.southAmerica, -5, 12, 10, 'EC', 'H[CD]', [
      DxccEntity._('Galapagos Islands', 71, Continent.southAmerica, -6, 12, 10,
          'EC', 'H[CD]8'),
    ]),
    DxccEntity._(
        'Egypt', 478, Continent.africa, 2, 38, 34, 'EG', '6[AB]|SU|SS[A-M]'),
    DxccEntity._(
        'El Salvador', 74, Continent.northAmerica, -6, 11, 7, 'SV', 'HU|YS'),
    DxccEntity._(
        'Equatorial Guinea', 49, Continent.africa, -1, 47, 36, 'GQ', '3C', [
      DxccEntity._(
          'Annobon Island', 195, Continent.africa, -1, 52, 36, 'GQ', '3C0'),
    ]),
    DxccEntity._('Eritrea', 51, Continent.africa, 3, 48, 37, 'ER', 'E3'),
    DxccEntity._('Estonia', 52, Continent.europe, 2, 29, 15, 'EE', 'ES'),
    DxccEntity._('Eswatini', 468, Continent.africa, 2, 57, 38, 'SZ', '3D[A-M]'),
    DxccEntity._('Ethiopia', 53, Continent.africa, 3, 48, 37, 'ET', '9[EF]|ET'),
    DxccEntity._('Fiji', 176, Continent.oceania, 12, 56, 32, 'FJ', '3D[N-Z2]', [
      DxccEntity._('Conway Reef', 489, Continent.oceania, 12, 56, 32, 'FJ',
          r'3D2(.*\/)?C'),
      DxccEntity._(
          'Rotuma', 460, Continent.oceania, 12, 56, 32, 'FJ', r'3D2(.*\/)?R'),
    ]),
    DxccEntity._('Finland', 224, Continent.europe, 2, 18, 15, 'FI', 'O[F-J]', [
      DxccEntity._(
          'Aland Islands', 5, Continent.europe, 2, 18, 15, 'AX', 'O[FGH]0'),
      DxccEntity._(
          'Market Reef', 167, Continent.europe, 2, 18, 15, 'AX', 'OH0M|OJ0'),
    ]),
    DxccEntity._('France', 227, Continent.europe, 1, 27, 14, 'FR',
        'F[A-Z]?|H[WXY]|T[HKMOPQVWX]', [
      // TODO WHAT French Polynesia, Clipperton Island, Marquesas, Austral Island
      DxccEntity._('Amsterdam and St Paul Islands', 10, Continent.africa, 5, 68,
          39, 'FR', 'FT[0258]Z'),
      DxccEntity._(
          'Austral Islands', 508, Continent.oceania, -10, 63, 32, 'PF', 'FO0'),
      DxccEntity._('Clipperton Island', 36, Continent.northAmerica, -7, 10, 7,
          'FR', 'FO0'),
      DxccEntity._('Corsica', 214, Continent.europe, 1, 28, 15, 'FR', 'TK'),
      DxccEntity._(
          'Crozet Island', 41, Continent.africa, 3, 68, 39, 'FR', 'FT[0258]W'),
      DxccEntity._('Chesterfield Islands', 512, Continent.oceania, 11, 55, 30,
          'GB', 'TX'),
      DxccEntity._(
          'French Guiana', 63, Continent.southAmerica, -4, 12, 9, 'FR', 'FY'),
      DxccEntity._(
          'French Polynesia', 175, Continent.oceania, -10, 63, 32, 'PF', 'FO'),
      DxccEntity._('Glorioso Islands', 99, Continent.africa, 3, 53, 39, 'FR',
          r'FR.*\/G'),
      DxccEntity._(
          'Guadeloupe', 79, Continent.northAmerica, -4, 11, 8, 'FR', 'FG'),
      DxccEntity._('Juan de Nova Island', 124, Continent.africa, 3, 53, 39,
          'FR', r'FR.*\/J'),
      DxccEntity._('Kerguelen Islands', 131, Continent.africa, 5, 68, 39, 'FR',
          'FT[0258]X'),
      DxccEntity._('Marquesas Islands', 509, Continent.oceania, -10, 63, 31,
          'FR', 'FO0'),
      DxccEntity._(
          'Martinique', 84, Continent.northAmerica, -4, 11, 8, 'MQ', 'FM'),
      DxccEntity._('Mayotte', 169, Continent.africa, 3, 53, 39, 'YT', 'FH'),
      DxccEntity._(
          'New Caledonia', 162, Continent.oceania, 11, 56, 32, 'NC', 'FK'),
      DxccEntity._('Reunion', 453, Continent.africa, 4, 53, 39, 'FR', 'FR'),
      DxccEntity._(
          'St Martin', 213, Continent.northAmerica, -4, 11, 8, 'FR', 'F[JS]'),
      DxccEntity._('St Pierre & Miquelon', 277, Continent.northAmerica, -4, 9,
          5, 'CA', 'FP'),
      DxccEntity._(
          'St. Barthelemy', 516, Continent.northAmerica, 0, 0, 0, 'FR', 'FJ'),
      DxccEntity._('Tromelin Island', 276, Continent.africa, 4, 53, 39, 'FR',
          r'FR.*\/T'),
      DxccEntity._('Wallis and Futuna Islands', 298, Continent.oceania, -11, 62,
          32, 'WF', 'FW'),
    ]),
    DxccEntity._('Gabon', 420, Continent.africa, 1, 52, 36, 'GA', 'TR'),
    DxccEntity._('Georgia', 75, Continent.asia, 4, 29, 21, 'GE', '4L'),
    DxccEntity._(
        'Germany', 230, Continent.europe, 1, 28, 14, 'DE', 'D[A-R]|Y[2-9]'),
    DxccEntity._('Ghana', 424, Continent.africa, 0, 46, 35, 'GH', '9G'),
    DxccEntity._(
        'Greece', 236, Continent.europe, 2, 28, 20, 'GR', 'J4|S[V-Z]', [
      DxccEntity._(
          'Crete', 40, Continent.europe, 2, 28, 20, 'GR', 'J49|S[VWX]9'),
      DxccEntity._(
          'Dodecanese', 45, Continent.europe, 2, 28, 20, 'GR', 'J45|S[VWX]5'),
      DxccEntity._(
          'Mt Athos', 180, Continent.europe, 2, 28, 20, 'GR', r'SV.*\/A|SY'),
    ]),
    DxccEntity._('Grenada', 77, Continent.northAmerica, -4, 11, 8, 'GD', 'J3'),
    DxccEntity._(
        'Guatemala', 76, Continent.northAmerica, -6, 11, 7, 'GT', 'T[DG]'),
    DxccEntity._('Guinea', 107, Continent.africa, 0, 46, 35, 'GN', '3X'),
    DxccEntity._(
        'Guinea-Bissau', 109, Continent.africa, -1, 46, 35, 'GW', 'J5'),
    DxccEntity._('Guyana', 129, Continent.southAmerica, -4, 12, 9, 'GY', '8R'),
    DxccEntity._('Haiti', 78, Continent.northAmerica, -5, 11, 8, 'HT', '4V|HH'),
    DxccEntity._(
        'Honduras', 80, Continent.northAmerica, -6, 11, 7, 'HN', 'H[QR]'),
    DxccEntity._('Hungary', 239, Continent.europe, 1, 28, 15, 'HU', 'H[AG]'),
    DxccEntity._('Iceland', 242, Continent.europe, 0, 17, 40, 'IS', 'TF'),
    DxccEntity._(
        'India', 324, Continent.asia, 6, 41, 22, 'IN', '8[T-Y]|[AV][T-W]', [
      DxccEntity._('Andaman and Nicobar Islands', 11, Continent.asia, 6, 49, 26,
          'IN', '[8A][TUVW]4|VU4'),
      DxccEntity._('Lakshadweep Islands', 142, Continent.asia, 6, 41, 22, 'IN',
          '[8A][TUVW]7|VU7'),
    ]),
    DxccEntity._('Indonesia', 327, Continent.oceania, 8, 51, 28, 'ID',
        '[78][A-I]|JZ|P[K-O]|Y[B-H]'),
    DxccEntity._('Iran', 330, Continent.asia, 4, 40, 21, 'IR', '9[BCD]|E[PQ]'),
    DxccEntity._('Iraq', 333, Continent.asia, 3, 39, 21, 'IQ', 'HN|YI'),
    DxccEntity._('Ireland', 245, Continent.europe, 0, 27, 14, 'IE', 'E[IJ]'),
    DxccEntity._('Israel', 336, Continent.asia, 2, 39, 20, 'IL', '4[XZ]'),
    DxccEntity._('Italy', 248, Continent.europe, 1, 28, 15, 'IT', 'I[A-Z]?', [
      DxccEntity._(
          'Sardinia', 225, Continent.europe, 1, 28, 15, 'IT', 'I[SM]0'),
    ]),
    DxccEntity._('Ivory Coast', 428, Continent.africa, 0, 46, 35, 'CI', 'TU'),
    DxccEntity._('Jamaica', 82, Continent.northAmerica, -5, 11, 8, 'JM', '6Y'),
    DxccEntity._(
        'Japan', 339, Continent.asia, 9, 45, 25, 'JP', '[78][J-N]|J[A-S]', [
      DxccEntity._(
          'Minami Torishima', 177, Continent.oceania, 10, 90, 27, 'JP', 'JD1M'),
      DxccEntity._('Ogasawara', 192, Continent.asia, 10, 45, 27, 'JP', 'JD1O'),
    ]),
    DxccEntity._('Jordan', 342, Continent.asia, 2, 39, 20, 'JO', 'JY'),
    DxccEntity._('Kazakhstan', 130, Continent.asia, 6, 29, 17, 'KZ', 'U[N-Q]'),
    DxccEntity._('Kenya', 430, Continent.africa, 3, 48, 37, 'KE', '5[YZ]'),
    DxccEntity._('Kiribati', 301, Continent.oceania, 12, 65, 31, 'KI', 'T3', [
      DxccEntity._(
          'Banaba Island', 490, Continent.oceania, 12, 65, 31, 'KI', 'T33'),
      DxccEntity._(
          'Central Kiribati', 31, Continent.oceania, 12, 62, 31, 'KI', 'T31'),
      DxccEntity._(
          'East Kiribati', 48, Continent.oceania, 12, 61, 31, 'KI', 'T32'),
    ]),
    DxccEntity._('Kuwait', 348, Continent.asia, 3, 39, 21, 'KW', '9K'),
    DxccEntity._('Kyrgyzstan', 135, Continent.asia, 6, 30, 17, 'KG', 'EX'),
    DxccEntity._('Laos', 143, Continent.asia, 7, 49, 26, 'LA', 'XW'),
    DxccEntity._('Latvia', 145, Continent.europe, 2, 29, 15, 'LV', 'YL'),
    DxccEntity._('Lebanon', 354, Continent.asia, 2, 39, 20, 'LB', 'OD'),
    DxccEntity._('Lesotho', 432, Continent.africa, 2, 57, 38, 'LS', '7P'),
    DxccEntity._('Liberia', 434, Continent.africa, -1, 46, 35, 'LR',
        '5[LM]|6Z|A8|D5|EL'),
    DxccEntity._('Libya', 436, Continent.africa, 2, 38, 34, 'LY', '5A'),
    DxccEntity._('Lithuania', 146, Continent.europe, 2, 29, 15, 'LT', 'LY'),
    DxccEntity._('Luxembourg', 254, Continent.europe, 1, 27, 14, 'LU', 'LX'),
    DxccEntity._(
        'Madagascar', 438, Continent.africa, 3, 53, 39, 'MG', '5[RS]|6X'),
    DxccEntity._('Malawi', 440, Continent.africa, 2, 53, 37, 'MW', '7Q'),
    DxccEntity._('Maldives', 159, Continent.asia, 5, 41, 22, 'MV', '8Q'),
    DxccEntity._('Mali', 442, Continent.africa, 0, 46, 35, 'ML', 'TZ'),
    DxccEntity._('Malta', 257, Continent.europe, 1, 28, 15, 'MT', '9H'),
    DxccEntity._(
        'Marshall Islands', 168, Continent.oceania, 12, 65, 31, 'MH', 'V7'),
    DxccEntity._('Mauritania', 444, Continent.africa, -1, 46, 35, 'MR', '5T'),
    DxccEntity._('Mauritius', 165, Continent.africa, 4, 53, 39, 'MU', '3B', [
      DxccEntity._('Agalega and St Brandon', 4, Continent.africa, 4, 53, 39,
          'MP', '3B[67]'),
      DxccEntity._(
          'Rodriguez Island', 207, Continent.africa, 4, 53, 39, 'MU', '3B9'),
    ]),
    DxccEntity._('Mexico', 50, Continent.northAmerica, -6, 10, 6, 'MX',
        '4[ABC]|6[D-J]|X[A-I]', [
      DxccEntity._('Revillagigedo Islands', 204, Continent.northAmerica, -7, 10,
          6, 'MX', 'XF[04]'),
    ]),
    DxccEntity._('Micronesia', 173, Continent.oceania, 11, 65, 27, 'FM', 'V6'),
    DxccEntity._('Moldova', 179, Continent.europe, 3, 29, 16, 'MD', 'ER'),
    DxccEntity._('Monaco', 260, Continent.europe, 1, 27, 14, 'MC', '3A'),
    DxccEntity._('Mongolia', 363, Continent.asia, 8, 32, 23, 'MN', 'J[TUV]'),
    DxccEntity._('Montenegro', 514, Continent.europe, 1, 28, 15, 'ME', '4O'),
    DxccEntity._(
        'Morocco', 446, Continent.africa, 0, 37, 33, 'MA', '5[C-G]|CN'),
    DxccEntity._('Mozambique', 181, Continent.africa, 2, 53, 37, 'MZ', 'C[89]'),
    DxccEntity._(
        'Myanmar (Burma)', 309, Continent.asia, 7, 49, 26, 'MM', 'X[YZ]'),
    DxccEntity._('Namibia', 464, Continent.africa, 2, 57, 38, 'NA', 'V5'),
    DxccEntity._('Nauru', 157, Continent.oceania, 12, 65, 31, 'NR', 'C2'),
    DxccEntity._('Nepal', 369, Continent.asia, 545, 42, 22, 'NP', '9N'),
    DxccEntity._(
        'Netherlands', 263, Continent.europe, 1, 27, 14, 'NL', 'P[A-J4]', [
      DxccEntity._('Aruba', 91, Continent.southAmerica, -4, 11, 9, 'AW', 'P4'),
      DxccEntity._(
          'Bonaire', 520, Continent.southAmerica, 0, 11, 9, 'BQ1', 'PJ4'),
      DxccEntity._(
          'Curacao', 517, Continent.southAmerica, -4, 11, 9, 'CW', 'PJ2'),
      DxccEntity._('Saba, St Eustatius', 519, Continent.northAmerica, -4, 11, 8,
          'AN', 'PJ[56]'),
      DxccEntity._(
          'St. Maarten', 518, Continent.northAmerica, 0, 11, 8, 'SX', 'PJ7'),
    ]),
    DxccEntity._('New Zealand', 170, Continent.oceania, 12, 60, 32, 'NZ',
        'Z[KLM]|E[56]', [
      DxccEntity._('Auckland, Campbell Islands', 16, Continent.oceania, 12, 60,
          32, 'NZ', 'Z[LM]9'),
      DxccEntity._(
          'Chatham Islands', 34, Continent.oceania, 13, 60, 32, 'NZ', 'Z[LM]7'),
      DxccEntity._('Kermadec Islands', 133, Continent.oceania, 12, 60, 32, 'NZ',
          'Z[LM]8'),
      DxccEntity._('Niue', 188, Continent.oceania, -11, 62, 32, 'NU', 'ZK2'),
      DxccEntity._('North Cook Islands', 191, Continent.oceania, -11, 62, 32,
          'NZ', r'ZK1.*\/N'),
      DxccEntity._('South Cook Islands', 234, Continent.oceania, -11, 63, 32,
          'GS', r'ZK1.*\/S'),
      DxccEntity._(
          'Tokelau Islands', 270, Continent.oceania, -11, 62, 31, 'TK', 'ZK3'),
    ]),
    DxccEntity._(
        'Nicaragua', 86, Continent.northAmerica, -6, 11, 7, 'NI', 'H[67T]|YN'),
    DxccEntity._('Niger', 187, Continent.africa, 1, 46, 35, 'NE', '5U'),
    DxccEntity._('Nigeria', 450, Continent.africa, 1, 46, 35, 'NG', '5[NO]'),
    DxccEntity._(
        'North Korea', 344, Continent.asia, 9, 44, 25, 'KP', 'HM|P[5-9]'),
    DxccEntity._(
        'North Macedonia', 502, Continent.europe, 1, 28, 15, 'MK', 'Z3'),
    DxccEntity._('Northern Cyprus', 901, Continent.asia, 2, 39, 20, 'ZP', '1B'),
    DxccEntity._(
        'Norway', 266, Continent.europe, 1, 18, 14, 'NO', '3Y|J[WX]|L[A-N]', [
      DxccEntity._('Bouvet Island', 24, Continent.africa, 0, 67, 38, 'NO',
          r'3Y5|3Y[^0].*\/B'),
      DxccEntity._(
          'Jan Mayen Island', 118, Continent.europe, -1, 18, 40, 'NO', 'JX'),
      DxccEntity._('Peter I Island', 199, Continent.antartica, -6, 72, 12, 'NO',
          r'3Y0|3Y[^5].*\/P'),
      DxccEntity._('Svalbard', 259, Continent.europe, 1, 18, 40, 'NO', 'JW'),
    ]),
    DxccEntity._('Oman', 370, Continent.asia, 4, 39, 21, 'OM', 'A4'),
    DxccEntity._('Pakistan', 372, Continent.asia, 5, 41, 21, 'PK', '[6A][P-S]'),
    DxccEntity._('Palau', 22, Continent.oceania, 10, 64, 27, 'PW', 'T8'),
    DxccEntity._('Palestine', 510, Continent.asia, 2, 39, 20, 'PS', 'E4'),
    DxccEntity._('Panama', 88, Continent.northAmerica, -5, 11, 7, 'PA',
        '3[EF]|H[389OP]'),
    DxccEntity._(
        'Papua New Guinea', 163, Continent.oceania, 10, 51, 28, 'PG', 'P2'),
    DxccEntity._(
        'Paraguay', 132, Continent.southAmerica, -4, 14, 11, 'PY', 'ZP'),
    DxccEntity._(
        'Peru', 136, Continent.southAmerica, -5, 12, 10, 'PE', '4T|O[ABC]'),
    DxccEntity._('Philippines', 375, Continent.oceania, 8, 50, 27, 'PH',
        '4[D-I]|D[U-Z]'),
    DxccEntity._(
        'Poland', 269, Continent.europe, 1, 28, 15, 'PL', '3Z|HF|S[N-R]'),
    DxccEntity._('Portugal', 272, Continent.europe, 0, 37, 14, 'PT', 'C[Q-U]', [
      DxccEntity._('Azores', 149, Continent.europe, -1, 36, 14, 'PZ', 'CU'),
      DxccEntity._('Madeira Island', 256, Continent.africa, -1, 36, 33, 'X2',
          'C[QRT][39]'),
    ]),

    DxccEntity._('Qatar', 376, Continent.asia, 4, 39, 21, 'QA', 'A7'),
    DxccEntity._(
        'Republic of Kosovo', 522, Continent.europe, 1, 28, 15, 'ZK', 'Z6'),
    DxccEntity._('Romania', 275, Continent.europe, 2, 28, 20, 'RO', 'Y[O-R]'),
    DxccEntity._(
        'Russia', 54, Continent.europe, 3, 19, 16, 'RU', 'R[A-Z]?|U[A-I]', [
      DxccEntity._('Asiatic Russia', 15, Continent.asia, 7, 20, 16, 'RU',
          'U[A-I]?[0789]|R[A-Z]?[0789]'),
      DxccEntity._(
          'Franz Josef Land', 61, Continent.europe, 3, 75, 40, 'RU', 'R1FJ'),
      DxccEntity._('Kaliningrad', 126, Continent.europe, 2, 29, 15, 'RU',
          'U[A-I]?2|R[A-Z]?2'),
    ]),
    DxccEntity._('Rwanda', 454, Continent.africa, 3, 52, 36, 'RW', '9X'),
    DxccEntity._('Samoa', 190, Continent.oceania, -11, 62, 32, 'WS', '5W'),

    DxccEntity._('San Marino', 278, Continent.europe, 1, 28, 15, 'SM', 'T7'),
    DxccEntity._(
        'Sao Tome & Principe', 219, Continent.africa, 0, 47, 36, 'ST', 'S9'),
    DxccEntity._(
        'Saudi Arabia', 378, Continent.asia, 3, 39, 21, 'SA', '[78H]Z', [
      DxccEntity._('Saudi Arabia/Iraq Neutral Zone', 1378, Continent.asia, 3,
          39, 21, 'SA', '8Z4'),
    ]),
    DxccEntity._('Senegal', 456, Continent.africa, 0, 46, 35, 'SN', '6[VW]'),
    DxccEntity._('Serbia', 296, Continent.europe, 1, 28, 15, 'RS', 'Y[TU]'),
    DxccEntity._('Seychelles', 379, Continent.africa, 4, 53, 39, 'SC', 'S7'),
    DxccEntity._('Sierra Leone', 458, Continent.africa, 0, 46, 35, 'SL', '9L'),
    DxccEntity._('Singapore', 381, Continent.asia, 8, 54, 28, 'SG', '9V|S6'),
    DxccEntity._(
        'Slovak Republic', 504, Continent.europe, 1, 28, 15, 'SK', 'OM'),
    DxccEntity._('Slovenia', 499, Continent.europe, 1, 28, 15, 'SI', 'S5'),
    DxccEntity._('SMO Malta', 246, Continent.europe, 1, 28, 15, 'X1', '1A0'),
    DxccEntity._(
        'Solomon Islands', 185, Continent.oceania, 11, 51, 28, 'SB', 'H4', [
      DxccEntity._('Temotu', 507, Continent.oceania, 11, 51, 28, 'SB', 'H40'),
    ]),
    DxccEntity._('Somalia', 232, Continent.africa, 3, 48, 37, 'SO', '6O|T5'),
    DxccEntity._(
        'South Africa', 462, Continent.africa, 2, 57, 38, 'ZA', 'S8|Z[R-U]', [
      DxccEntity._('Prince Edward and Marion Island', 201, Continent.africa, 3,
          57, 38, 'ZA', 'VY[29]|ZS[28]'),
    ]),
    DxccEntity._('South Korea', 137, Continent.asia, 9, 44, 25, 'KR',
        '6[K-N]|D[789ST]|HL'),
    DxccEntity._('South Sudan', 521, Continent.africa, 0, 0, 0, 'SS', 'Z8'),
    DxccEntity._(
        'Spain', 281, Continent.europe, 1, 37, 14, 'ES', 'A[MNO]|E[A-H]', [
      DxccEntity._('Balearic Islands', 21, Continent.europe, 1, 37, 14, 'ES',
          'A[MNO]6|E[A-H]6'),
      DxccEntity._('Canary Islands', 29, Continent.africa, 0, 36, 33, 'ES',
          'A[MNO]8|E[A-H]8'),
      DxccEntity._('Ceuta and Melilla', 32, Continent.africa, 1, 37, 33, 'ES',
          'A[MNO]9|E[A-H]9'),
    ]),
    // Abc('Spratly Islands', 247, Continent.Asia, 7, 50, 26, 'PH'),
    DxccEntity._('Sri Lanka', 315, Continent.asia, 6, 41, 22, 'LK', '4[P-S]'),
    DxccEntity._('St Kitts and Nevis', 249, Continent.northAmerica, -4, 11, 8,
        'KN', 'V4'),
    DxccEntity._('St Lucia', 97, Continent.northAmerica, -4, 11, 8, 'LC', 'J6'),

    DxccEntity._(
        'St Vincent', 98, Continent.northAmerica, -4, 11, 8, 'VC', 'J8'),
    DxccEntity._(
        'Sudan', 466, Continent.africa, 2, 48, 34, 'SD', '6[TU]|ST|SS[N-Z]'),
    DxccEntity._(
        'Suriname', 140, Continent.southAmerica, -4, 12, 9, 'SR', 'PZ'),
    DxccEntity._(
        'Sweden', 284, Continent.europe, 1, 18, 14, 'SE', '[78]S|S[A-M]'),
    DxccEntity._(
        'Switzerland', 287, Continent.europe, 1, 28, 14, 'CH', 'H[BE]', [
      DxccEntity._(
          'Liechtenstein', 251, Continent.europe, 1, 28, 14, 'LI', 'HB0'),
    ]),
    DxccEntity._('Syria', 384, Continent.asia, 2, 39, 20, 'SY', '6C|YK'),

    DxccEntity._('Tajikistan', 262, Continent.asia, 6, 30, 17, 'TJ', 'EY'),
    DxccEntity._('Tanzania', 470, Continent.africa, 3, 53, 37, 'TZ', '5[HI]'),
    DxccEntity._('Thailand', 387, Continent.asia, 7, 49, 26, 'TH', 'E2|HS'),
    DxccEntity._('The Gambia', 422, Continent.africa, 0, 46, 35, 'GM', 'C5'),
    DxccEntity._('Timor Leste', 511, Continent.oceania, 8, 54, 28, 'TL', '4W'),
    DxccEntity._('Togo', 483, Continent.africa, 0, 46, 35, 'TG', '5V'),
    DxccEntity._('Tonga', 160, Continent.oceania, 13, 62, 32, 'TO', 'A3'),

    DxccEntity._('Trinidad and Tobago', 90, Continent.southAmerica, -4, 11, 9,
        'TT', '9[YZ]'),
    DxccEntity._('Tunisia', 474, Continent.africa, 1, 37, 33, 'TN', '3V|TS'),
    DxccEntity._('Turkey', 390, Continent.asia, 2, 39, 20, 'TR', 'T[ABC]|YM'),
    DxccEntity._('Turkmenistan', 280, Continent.asia, 5, 30, 17, 'TM', 'EZ'),
    DxccEntity._('Tuvalu', 282, Continent.oceania, 12, 65, 31, 'TV', 'T2'),
    DxccEntity._('Uganda', 286, Continent.africa, 3, 48, 37, 'UG', '5X'),
    DxccEntity._(
        'Ukraine', 288, Continent.europe, 2, 29, 16, 'UA', 'E[NMO]|U[R-Z]'),
    DxccEntity._(
        'United Arab Emirates', 391, Continent.asia, 4, 39, 21, 'AE', 'A6'),

    DxccEntity._('United Kingdom', 223, Continent.europe, 0, 27, 14, 'GB',
        '[GM]|[2GM][A-Z]|V[PQS]|Z[B-JNOQ]', [
      DxccEntity._(
          'Anguilla', 12, Continent.northAmerica, -4, 11, 8, 'AI', 'VP2E'),
      DxccEntity._(
          'Ascension Island', 205, Continent.africa, 0, 66, 36, 'KY', 'ZD8'),
      DxccEntity._(
          'Bermuda', 64, Continent.northAmerica, -4, 11, 5, 'BM', 'VP9'),
      DxccEntity._('British Virgin Islands', 65, Continent.northAmerica, -4, 11,
          8, 'VG', 'VP2V'),
      DxccEntity._(
          'Cayman Islands', 69, Continent.northAmerica, -5, 11, 8, 'KY', 'ZF'),
      DxccEntity._(
          'Chagos Islands', 33, Continent.africa, 5, 41, 39, 'GB', 'VQ9'),
      DxccEntity._('Cyprus SBA', 283, Continent.asia, 2, 39, 20, 'CY', 'ZC4'),
      DxccEntity._('Falkland Islands', 141, Continent.southAmerica, -4, 16, 13,
          'FK', r'VP8.*\/F'),
      DxccEntity._('Gibraltar', 233, Continent.europe, 1, 37, 14, 'GI', 'ZB'),
      DxccEntity._(
          'Guernsey', 106, Continent.europe, 0, 27, 14, 'GG', '2U|[GM][UP]'),
      DxccEntity._(
          'Isle of Man', 114, Continent.europe, 0, 27, 14, 'IM', '[GM][DT]|2D'),
      DxccEntity._(
          'Jersey', 122, Continent.europe, 0, 27, 14, 'JE', '[GM][HJ]|2J'),
      DxccEntity._(
          'Montserrat', 96, Continent.northAmerica, -4, 11, 8, 'MS', 'VP2M'),
      DxccEntity._('Northern Ireland', 265, Continent.europe, 0, 27, 14, 'IE',
          '[GM][IN]|2I'),
      DxccEntity._(
          'Pitcairn Islands', 172, Continent.oceania, -9, 63, 32, 'PN', 'VP6'),
      DxccEntity._(
          'Scotland', 279, Continent.europe, 0, 27, 14, 'ZC', '[GM][MSZ]|2M'),
      DxccEntity._('South Georgia Islands', 235, Continent.southAmerica, -2, 73,
          13, 'GS', r'VP8.*\/G'),
      DxccEntity._('South Orkney Islands', 238, Continent.southAmerica, -3, 73,
          13, 'GB', r'VP8.*\/O'),
      DxccEntity._('South Sandwich Islands', 240, Continent.southAmerica, -3,
          73, 13, 'GS', r'VP8.*\/SA'),
      DxccEntity._('South Shetland Islands', 241, Continent.southAmerica, -4,
          73, 13, 'GB', r'VP8.*\/SH'),
      DxccEntity._(
          'St Helena Island', 250, Continent.africa, 0, 66, 36, 'SH', 'ZD7'),
      DxccEntity._('Tristan da Cunha and Gough Island', 274, Continent.africa,
          0, 66, 38, 'GB', 'ZD9'),
      DxccEntity._('Turks and Caicos Islands', 89, Continent.northAmerica, -5,
          11, 8, 'TC', 'VP5'),
      DxccEntity._(
          'Wales', 294, Continent.europe, 0, 27, 14, 'GB', '[GM][WC]|2W'),
    ]),
    DxccEntity._(
        'United Nations', 289, Continent.northAmerica, -5, 8, 5, 'UN', '4U', [
      DxccEntity._(
          'ITU Geneva', 117, Continent.europe, 1, 28, 14, 'CH', '4U.*ITU'),
    ]),
    DxccEntity._('United States', 291, Continent.northAmerica, -5, 0, 0, 'US',
        'A[A-L]|[KNW][A-Z]?', [
      DxccEntity._(
          'Alaska', 6, Continent.northAmerica, -8, 1, 1, 'US', '[AKNW]L'),
      DxccEntity._('American Samoa', 9, Continent.oceania, -11, 62, 32, 'AS',
          '[AKNW]H8'),
      DxccEntity._('Baker and Howland Islands', 20, Continent.oceania, -12, 61,
          31, 'US', '[AKNW]H1'),
      DxccEntity._('Desecheo Island', 43, Continent.northAmerica, -4, 11, 8,
          'PR', '[KNW]P5'),
      DxccEntity._('Puerto Rico', 202, Continent.northAmerica, -4, 11, 8, 'PR',
          '[KNW]P[34]'),
      DxccEntity._(
          'Guam', 103, Continent.oceania, 10, 64, 27, 'GU', '[AKNW]H2'),
      DxccEntity._('Guantanamo Bay', 105, Continent.northAmerica, -5, 11, 8,
          'US', 'KG4'),
      DxccEntity._(
          'Hawaii', 110, Continent.oceania, -10, 61, 31, 'US', '[AKNW]H[67]'),
      DxccEntity._('Johnston Island', 123, Continent.oceania, -11, 61, 31, 'US',
          '[AKNW]H3'),
      DxccEntity._('Kingman Reef', 134, Continent.oceania, -11, 61, 31, 'US',
          '[AKNW]H5K'),
      DxccEntity._(
          'Kure Atoll', 138, Continent.oceania, -11, 61, 31, 'US', '[AKNW]H7K'),
      DxccEntity._('Mariana Islands', 166, Continent.oceania, 10, 64, 27, 'US',
          '[AKNW]H0'),
      DxccEntity._('Midway Islands', 174, Continent.oceania, -11, 61, 31, 'US',
          '[AKNW]H4'),
      DxccEntity._('Navassa Island', 182, Continent.northAmerica, -5, 11, 8,
          'US', '[KNW]P1'),
      DxccEntity._('Palmyra, Jarvis Island', 197, Continent.oceania, -11, 61,
          31, 'US', '[AKNW]H5'),
      DxccEntity._('Swains Island', 515, Continent.oceania, -11, 62, 32, 'US',
          '[AKNW]H8S'),
      DxccEntity._('US Virgin Islands', 285, Continent.northAmerica, -4, 11, 8,
          'VI', '[KNW]P2'),
      DxccEntity._(
          'Wake Island', 297, Continent.oceania, 12, 65, 31, 'US', '[AKNW]H9'),
    ]),
    DxccEntity._(
        'Uruguay', 144, Continent.southAmerica, -3, 14, 13, 'UY', 'C[V-X]'),
    DxccEntity._('Uzbekistan', 292, Continent.asia, 6, 30, 17, 'UZ', 'U[J-M]'),
    DxccEntity._('Vanuatu', 158, Continent.oceania, 11, 56, 32, 'VU', 'YJ'),
    DxccEntity._('Vatican', 295, Continent.europe, 1, 28, 15, 'VA', 'HV'),
    DxccEntity._('Venezuela', 148, Continent.southAmerica, -4, 12, 9, 'VE',
        '4M|Y[V-Y]', [
      DxccEntity._(
          'Aves Island', 17, Continent.northAmerica, -4, 11, 8, 'VE', 'Y[VX]0'),
    ]),
    DxccEntity._('Vietnam', 293, Continent.asia, 7, 49, 26, 'VN', '3W|XV'),
    DxccEntity._('Malaysia', 299, Continent.asia, 8, 54, 28, 'MY', '9[MW]', [
      DxccEntity._(
          'East Malaysia', 46, Continent.oceania, 8, 54, 28, 'MY', '9M[68]'),
    ]),
    DxccEntity._(
        'Western Sahara', 302, Continent.africa, 0, 46, 33, 'EH', 'S0'),
    DxccEntity._('Yemen', 492, Continent.asia, 3, 39, 21, 'YE', '7O'),
    DxccEntity._('Zambia', 482, Continent.africa, 2, 53, 36, 'ZM', '9[IJ]'),
    DxccEntity._('Zimbabwe', 452, Continent.africa, 2, 53, 38, 'ZW', 'Z2'),
  ];
}
