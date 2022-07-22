import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

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

  DxccEntity._(
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

  DxccEntity(
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

  late final RegExp prefixRe = RegExp('^$prefix', caseSensitive: false);

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

  static const _eu = Continent.europe;
  static const _as = Continent.asia;
  static const _af = Continent.africa;
  static const _sa = Continent.southAmerica;
  static const _na = Continent.northAmerica;
  static const _oc = Continent.oceania;
  static const _an = Continent.antartica;

  static DxccEntity _ctor(
    String name,
    int dxcc,
    Continent continent,
    int timezoneOffset,
    int ituZone,
    int cqZone,
    String flag,
    String prefix, [
    List<DxccEntity> sub = const [],
  ]) =>
      DxccEntity._(
        name,
        dxcc,
        continent,
        timezoneOffset,
        ituZone,
        cqZone,
        flag,
        prefix.replaceAll(r'$_s', _s),
        sub,
      );

  static const _s = '[A-Z0-9]*';

  static final dxccs = [
    // TODO _ctor('Spratly Islands', 247, _as, 7, 50, 26, 'PH'),
    _ctor('SMO Malta', 246, _eu, 1, 28, 15, 'X1', '1A'),
    _ctor('Monaco', 260, _eu, 1, 27, 14, 'MC', '3A'),
    _ctor('Mauritius', 165, _af, 4, 53, 39, 'MU', '3B', [
      _ctor('Agalega & St Brandon Is.', 4, _af, 4, 53, 39, 'MP', '3B[67]'),
      _ctor('Rodriguez Island', 207, _af, 4, 53, 39, 'MU', '3B9'),
    ]),
    _ctor('Equatorial Guinea', 49, _af, -1, 47, 36, 'GQ', '3C', [
      _ctor('Annobon Island', 195, _af, -1, 52, 36, 'GQ', '3C0'),
    ]),
    _ctor('Fiji', 176, _oc, 12, 56, 32, 'FJ', '3D2', [
      _ctor('Conway Reef', 489, _oc, 12, 56, 32, 'FJ', r'3D2($_s\/C\b|C)'),
      _ctor('Rotuma', 460, _oc, 12, 56, 32, 'FJ', r'3D2($_s\/R\b|R)'),
    ]),
    _ctor('Eswatini', 468, _af, 2, 57, 38, 'SZ', '3D[A-M]'),
    _ctor('Tunisia', 474, _af, 1, 37, 33, 'TN', '3V|TS'),
    _ctor('Vietnam', 293, _as, 7, 49, 26, 'VN', '3W|XV'),
    _ctor('Guinea', 107, _af, 0, 46, 35, 'GN', '3X'),
    _ctor('Bouvet Island', 24, _af, 0, 67, 38, 'NO', r'3Y5|3Y[^0]$_s\/B\b'),
    _ctor('Peter I Island', 199, _an, -6, 72, 12, 'NO', r'3Y0|3Y[^5]$_s\/P\b'),
    _ctor('Azerbaijan', 18, _as, 4, 29, 21, 'AZ', '4[JK]'),
    _ctor('Georgia', 75, _as, 4, 29, 21, 'GE', '4L'),
    _ctor('Montenegro', 514, _eu, 1, 28, 15, 'ME', '4O'),
    _ctor('Sri Lanka', 315, _as, 6, 41, 22, 'LK', '4[P-S]'),
    _ctor('ITU Geneva', 117, _eu, 1, 28, 14, 'CH', '4U.+ITU'),
    _ctor('United Nations', 289, _na, -5, 8, 5, 'UN', '4U.+UN'),
    _ctor('Timor Leste', 511, _oc, 8, 54, 28, 'TL', '4W'),
    _ctor('Israel', 336, _as, 2, 39, 20, 'IL', '4[XZ]'),
    _ctor('Libya', 436, _af, 2, 38, 34, 'LY', '5A'),
    _ctor('Cyprus', 215, _as, 3, 39, 20, 'CY', '5B|C4|H2|P3'),
    _ctor('Tanzania', 470, _af, 3, 53, 37, 'TZ', '5[HI]'),
    _ctor('Nigeria', 450, _af, 1, 46, 35, 'NG', '5[NO]'),
    _ctor('Madagascar', 438, _af, 3, 53, 39, 'MG', '5[RS]|6X'),
    _ctor('Mauritania', 444, _af, -1, 46, 35, 'MR', '5T'),
    _ctor('Niger', 187, _af, 1, 46, 35, 'NE', '5U'),
    _ctor('Togo', 483, _af, 0, 46, 35, 'TG', '5V'),
    _ctor('Samoa', 190, _oc, -11, 62, 32, 'WS', '5W'),
    _ctor('Uganda', 286, _af, 3, 48, 37, 'UG', '5X'),
    _ctor('Kenya', 430, _af, 3, 48, 37, 'KE', '5[YZ]'),
    _ctor('Senegal', 456, _af, 0, 46, 35, 'SN', '6[VW]'),
    _ctor('Jamaica', 82, _na, -5, 11, 8, 'JM', '6Y'),
    _ctor('Yemen', 492, _as, 3, 39, 21, 'YE', '7O'),
    _ctor('Lesotho', 432, _af, 2, 57, 38, 'LS', '7P'),
    _ctor('Malawi', 440, _af, 2, 53, 37, 'MW', '7Q'),
    _ctor('Algeria', 400, _af, 0, 37, 33, 'DZ', '7[RT-Y]'),
    _ctor('Barbados', 62, _na, -4, 11, 8, 'BB', '8P'),
    _ctor('Maldives', 159, _as, 5, 41, 22, 'MV', '8Q'),
    _ctor('Guyana', 129, _sa, -4, 12, 9, 'GY', '8R'),
    _ctor('Croatia', 497, _eu, 1, 28, 15, 'HR', '9A'),
    _ctor('Ghana', 424, _af, 0, 46, 35, 'GH', '9G'),
    _ctor('Malta', 257, _eu, 1, 28, 15, 'MT', '9H'),
    _ctor('Zambia', 482, _af, 2, 53, 36, 'ZM', '9[IJ]'),
    _ctor('Kuwait', 348, _as, 3, 39, 21, 'KW', '9K'),
    _ctor('Sierra Leone', 458, _af, 0, 46, 35, 'SL', '9L'),
    _ctor('West Malaysia', 299, _as, 8, 54, 28, 'MY', '9M[24]'),
    _ctor('East Malaysia', 46, _oc, 8, 54, 28, 'MY', '9M[68]'),
    _ctor('Nepal', 369, _as, 545, 42, 22, 'NP', '9N'),
    _ctor('Democratic Republic of the Congo', 414, _af, 1, 52, 36, 'CD',
        '9[O-T]'),
    _ctor('Burundi', 404, _af, 3, 52, 36, 'BI', '9U'),
    _ctor('Singapore', 381, _as, 8, 54, 28, 'SG', '9V|S6'),
    _ctor('Rwanda', 454, _af, 3, 52, 36, 'RW', '9X'),
    _ctor('Trinidad and Tobago', 90, _sa, -4, 11, 9, 'TT', '9[YZ]'),
    _ctor('Botswana', 402, _af, 2, 57, 38, 'BW', '8O|A2'),
    _ctor('Tonga', 160, _oc, 13, 62, 32, 'TO', 'A3'),
    _ctor('Oman', 370, _as, 4, 39, 21, 'OM', 'A4'),
    _ctor('Bhutan', 306, _as, 6, 41, 22, 'BT', 'A5'),
    _ctor('United Arab Emirates', 391, _as, 4, 39, 21, 'AE', 'A6'),
    _ctor('Qatar', 376, _as, 4, 39, 21, 'QA', 'A7'),
    _ctor('Bahrain', 304, _as, 4, 39, 21, 'BH', 'A9'),
    _ctor('Pakistan', 372, _as, 5, 41, 21, 'PK', '[6A][P-S]'),
    _ctor('China', 318, _as, 8, 33, 23, 'CN', '3[H-U]|B[A-Z]|XS', [
      _ctor('Scarborough Reef', 506, _as, 8, 50, 27, 'CN', 'BS7'),
      _ctor('Taiwan', 386, _as, 8, 44, 24, 'TW', 'B[M-QU-X]', [
        _ctor('Pratas Island', 505, _as, 8, 44, 24, 'TW', 'BV9P'),
      ]),
    ]),
    _ctor('Nauru', 157, _oc, 12, 65, 31, 'NR', 'C2'),
    _ctor('Andorra', 203, _eu, 1, 27, 14, 'AD', 'C3'),
    _ctor('The Gambia', 422, _af, 0, 46, 35, 'GM', 'C5'),
    _ctor('Bahamas', 60, _na, -5, 11, 8, 'BS', 'C6'),
    _ctor('Mozambique', 181, _af, 2, 53, 37, 'MZ', 'C[89]'),
    _ctor('Chile', 112, _sa, -4, 14, 12, 'CL', '3G|C[A-E]|X[QR]', [
      _ctor(
          'Easter Island', 47, _sa, -7, 63, 12, 'CL', 'CE0[AEFY]|XQ0Y|XR0[YZ]'),
      _ctor(
          'Juan Fernandez Islands', 125, _sa, -4, 14, 12, 'CL', 'CE0[IZ]|XQ0Z'),
      _ctor('San Felix', 217, _sa, -5, 14, 12, 'CL', '(CE|XQ)0X'),
    ]),
    // TODO _ctor('Antarctica', 13, _an, 0, 67, 12, 'AQ'),
    _ctor('Cuba', 70, _na, -5, 11, 8, 'CU', 'C[LMO]|T4'),
    _ctor('Morocco', 446, _af, 0, 37, 33, 'MA', '5[C-G]|CN'),
    _ctor('Bolivia', 104, _sa, -4, 12, 10, 'BO', 'CP'),
    // TODO Check
    _ctor('Portugal', 272, _eu, 0, 37, 14, 'PT', 'C[Q-T]', [
      _ctor('Madeira Island', 256, _af, -1, 36, 33, 'X2', 'C[Q-T][39]'),
    ]),
    _ctor('Azores', 149, _eu, -1, 36, 14, 'PZ', 'CU'),
    _ctor('Uruguay', 144, _sa, -3, 14, 13, 'UY', 'C[V-X]'),
    _ctor('Angola', 401, _af, 1, 52, 36, 'AO', 'D[23]'),
    _ctor('Cape Verde', 409, _af, -2, 46, 35, 'CV', 'D4'),
    _ctor('Comoros', 411, _af, 3, 53, 39, 'KM', 'D6'),
    _ctor('Germany', 230, _eu, 1, 28, 14, 'DE', 'D[A-R]|Y[2-9]'),
    _ctor('Philippines', 375, _oc, 8, 50, 27, 'PH', '4[D-I]|D[U-Z]'),
    _ctor('Eritrea', 51, _af, 3, 48, 37, 'ER', 'E3'),
    _ctor('Palestine', 510, _as, 2, 39, 20, 'PS', 'E4'),
    // TODO _ctor('North Cook Islands', 191, _oc, -11, 62, 32, 'NZ', 'E5'),
    // TODO _ctor('South Cook Islands', 234, _oc, -11, 63, 32, 'GS', 'E5'),
    // TODO Check
    _ctor('Niue', 188, _oc, -11, 62, 32, 'NU', 'ZK2|E6'),
    _ctor('Bosnia and Herzegovina', 501, _eu, 1, 28, 15, 'BA', 'E7|T9'),
    _ctor('Spain', 281, _eu, 1, 37, 14, 'ES', 'A[MNO]|E[A-H]', [
      _ctor('Balearic Islands', 21, _eu, 1, 37, 14, 'ES', 'A[MNO]6|E[A-H]6'),
      _ctor('Canary Islands', 29, _af, 0, 36, 33, 'ES', 'A[MNO]8|E[A-H]8'),
      _ctor('Ceuta and Melilla', 32, _af, 1, 37, 33, 'ES', 'A[MNO]9|E[A-H]9'),
    ]),
    _ctor('Ireland', 245, _eu, 0, 27, 14, 'IE', 'E[IJ]'),
    _ctor('Armenia', 14, _as, 4, 29, 21, 'AM', 'EK'),
    _ctor('Liberia', 434, _af, -1, 46, 35, 'LR', 'EL'),
    _ctor('Iran', 330, _as, 4, 40, 21, 'IR', '9[BCD]|E[PQ]'),
    _ctor('Moldova', 179, _eu, 3, 29, 16, 'MD', 'ER'),
    _ctor('Estonia', 52, _eu, 2, 29, 15, 'EE', 'ES'),
    _ctor('Ethiopia', 53, _af, 3, 48, 37, 'ET', '9F|ET'),
    _ctor('Belarus', 27, _eu, 2, 29, 16, 'BY', 'E[U-W]'),
    _ctor('Kyrgyzstan', 135, _as, 6, 30, 17, 'KG', 'EX'),
    _ctor('Tajikistan', 262, _as, 6, 30, 17, 'TJ', 'EY'),
    _ctor('Turkmenistan', 280, _as, 5, 30, 17, 'TM', 'EZ'),
    _ctor('France', 227, _eu, 1, 27, 14, 'FR', 'F[A-Z]?|H[WXY]|T[HMOPQVWX]', [
      // TODO WHAT French Polynesia, Clipperton Island, Marquesas, Austral Island
      // TO
      _ctor('Guadeloupe', 79, _na, -4, 11, 8, 'FR', 'FG'),
      _ctor('Mayotte', 169, _af, 3, 53, 39, 'YT', 'FH'),
      _ctor('St. Barthelemy', 516, _na, 0, 0, 0, 'FR', 'FJ'),
      _ctor('New Caledonia', 162, _oc, 11, 56, 32, 'NC', 'FK'),
      _ctor('Chesterfield Islands', 512, _oc, 11, 55, 30, 'GB', 'TX'),
      _ctor('Martinique', 84, _na, -4, 11, 8, 'MQ', 'FM'),
      _ctor('Austral Islands', 508, _oc, -10, 63, 32, 'PF', 'FO0'),
      _ctor('Clipperton Island', 36, _na, -7, 10, 7, 'FR', 'FO0'),
      _ctor('French Polynesia', 175, _oc, -10, 63, 32, 'PF', 'FO'),
      _ctor('Marquesas Islands', 509, _oc, -10, 63, 31, 'FR', 'FO0'),
      _ctor('St Pierre & Miquelon', 277, _na, -4, 9, 5, 'CA', 'FP'),
      _ctor('Reunion', 453, _af, 4, 53, 39, 'FR', 'FR'),
      _ctor('Glorioso Islands', 99, _af, 3, 53, 39, 'FR', r'FT$_s\/G\b'),
      _ctor('Juan de Nova Island', 124, _af, 3, 53, 39, 'FR', r'FT$_s\/[JE]\b'),
      _ctor('Tromelin Island', 276, _af, 4, 53, 39, 'FR', r'FT$_s\/T\b'),
      _ctor('St Martin', 213, _na, -4, 11, 8, 'FR', 'FS'),
      _ctor('Crozet Island', 41, _af, 3, 68, 39, 'FR', r'FT($_s\/W\b|\d+W)'),
      _ctor('Kerguelen Islands', 131, _af, 5, 68, 39, 'FR', r'FT$_s\/X\b'),
      _ctor('Amsterdam and St Paul Islands', 10, _af, 5, 68, 39, 'FR',
          r'FT($_s\/Z\b|\d+Z)'),
      _ctor('Wallis and Futuna Islands', 298, _oc, -11, 62, 32, 'WF', 'FW'),
      _ctor('French Guiana', 63, _sa, -4, 12, 9, 'FR', 'FY'),
    ]),
    _ctor('England', 223, _eu, 0, 27, 14, 'GB',
        '[2GM][A-Z]|V[PQ]|VS[0-5789]|Z[D-JNOQ]|[GM]', [
      _ctor('Isle of Man', 114, _eu, 0, 27, 14, 'IM', '[GM][DT]|2D'),
      _ctor('Northern Ireland', 265, _eu, 0, 27, 14, 'IE', '[GM][IN]|2I'),
      _ctor('Jersey', 122, _eu, 0, 27, 14, 'JE', '[GM][HJ]|2J'),
      _ctor('Scotland', 279, _eu, 0, 27, 14, 'ZC', '[GM][MSZ]|2M'),
      _ctor('Guernsey', 106, _eu, 0, 27, 14, 'GG', '2U|[GM][UP]'),
      _ctor('Wales', 294, _eu, 0, 27, 14, 'GB', '[GM][WC]|2W'),
      _ctor('Anguilla', 12, _na, -4, 11, 8, 'AI', 'VP2E'),
      _ctor('Montserrat', 96, _na, -4, 11, 8, 'MS', 'VP2M'),
      _ctor('British Virgin Islands', 65, _na, -4, 11, 8, 'VG', 'VP2V'),
      _ctor('Turks and Caicos Islands', 89, _na, -5, 11, 8, 'TC', 'VP5'),
      // TODO _ctor('Pitcairn Islands', 172, _oc, -9, 63, 32, 'PN', 'VP6'),
      // TODO _ctor('Ducie Island', 513, _oc, -9, 63, 32, 'PN', 'VP6'),
      _ctor('Falkland Islands', 141, _sa, -4, 16, 13, 'FK', r'VP8$_s\/F\b'),
      _ctor(
          'South Georgia Islands', 235, _sa, -2, 73, 13, 'GS', r'VP8$_s\/G\b'),
      _ctor('South Orkney Islands', 238, _sa, -3, 73, 13, 'GB', r'VP8$_s\/O\b'),
      _ctor('South Sandwich Islands', 240, _sa, -3, 73, 13, 'GS',
          r'VP8$_s\/SA\b'),
      _ctor('South Shetland Islands', 241, _sa, -4, 73, 13, 'GB',
          r'VP8$_s\/SH\b'),
      _ctor('Bermuda', 64, _na, -4, 11, 5, 'BM', 'VP9'),
      _ctor('Chagos Islands', 33, _af, 5, 41, 39, 'GB', 'VQ9'),
      _ctor('St Helena Island', 250, _af, 0, 66, 36, 'SH', 'ZD7'),
      _ctor('Ascension Island', 205, _af, 0, 66, 36, 'KY', 'ZD8'),
      _ctor('Tristan da Cunha and Gough Island', 274, _af, 0, 66, 38, 'GB',
          'ZD9'),
      _ctor('Cayman Islands', 69, _na, -5, 11, 8, 'KY', 'ZF'),
    ]),
    _ctor('Solomon Islands', 185, _oc, 11, 51, 28, 'SB', 'H4', [
      _ctor('Temotu', 507, _oc, 11, 51, 28, 'SB', 'H40'),
    ]),
    _ctor('Hungary', 239, _eu, 1, 28, 15, 'HU', 'H[AG]'),
    _ctor('Switzerland', 287, _eu, 1, 28, 14, 'CH', 'H[BE]', [
      _ctor('Liechtenstein', 251, _eu, 1, 28, 14, 'LI', 'H[BE]0'),
    ]),
    _ctor('Ecuador', 120, _sa, -5, 12, 10, 'EC', 'H[CD]', [
      _ctor('Galapagos Islands', 71, _sa, -6, 12, 10, 'EC', 'H[CD]8'),
    ]),
    _ctor('Haiti', 78, _na, -5, 11, 8, 'HT', '4V|HH'),
    _ctor('Dominican Republic', 72, _na, -4, 11, 8, 'DO', 'HI'),
    _ctor('Colombia', 116, _sa, -5, 12, 9, 'CO', '[5H][JK]', [
      _ctor('Malpelo Island', 161, _sa, -5, 12, 9, 'CO', r'HK0($_s\/M\b|M)'),
      _ctor('San Andres and Providencia', 216, _na, -6, 11, 7, 'CO',
          r'HK0($_s\/S\b|S)'),
    ]),
    _ctor('Republic of Korea', 137, _as, 9, 44, 25, 'KR', '6[K-N]|D[789ST]|HL'),
    _ctor('Panama', 88, _na, -5, 11, 7, 'PA', '3[EF]|H[389OP]'),
    _ctor('Honduras', 80, _na, -6, 11, 7, 'HN', 'H[QR]'),
    _ctor('Thailand', 387, _as, 7, 49, 26, 'TH', 'E2|HS'),
    _ctor('Vatican', 295, _eu, 1, 28, 15, 'VA', 'HV'),
    _ctor('Saudi Arabia', 378, _as, 3, 39, 21, 'SA', '[78H]Z'),
    _ctor('Italy', 248, _eu, 1, 28, 15, 'IT', 'I[A-Z]?', [
      _ctor('Sardinia', 225, _eu, 1, 28, 15, 'IT', 'I[SM]0'),
    ]),
    _ctor('Djibouti', 382, _af, 3, 48, 37, 'DJ', 'J2'),
    _ctor('Grenada', 77, _na, -4, 11, 8, 'GD', 'J3'),
    _ctor('Guinea-Bissau', 109, _af, -1, 46, 35, 'GW', 'J5'),
    _ctor('St Lucia', 97, _na, -4, 11, 8, 'LC', 'J6'),
    _ctor('Dominica', 95, _na, -4, 11, 8, 'DM', 'J7'),
    _ctor('St Vincent', 98, _na, -4, 11, 8, 'VC', 'J8'),
    _ctor('Japan', 339, _as, 9, 45, 25, 'JP', '[78][J-N]|J[A-S]', [
      _ctor('Minami Torishima', 177, _oc, 10, 90, 27, 'JP', 'JD1M'),
      _ctor('Ogasawara', 192, _as, 10, 45, 27, 'JP', 'JD1O'),
    ]),
    _ctor('Mongolia', 363, _as, 8, 32, 23, 'MN', 'J[TUV]'),
    _ctor('Svalbard', 259, _eu, 1, 18, 40, 'NO', 'JW'),
    _ctor('Jan Mayen Island', 118, _eu, -1, 18, 40, 'NO', 'JX'),
    _ctor('Jordan', 342, _as, 2, 39, 20, 'JO', 'JY'),
    _ctor('United States', 291, _na, -5, 0, 0, 'US', 'A[A-K]|[KNW][A-Z]?', [
      _ctor('Guantanamo Bay', 105, _na, -5, 11, 8, 'US', 'KG4'),
      _ctor('Mariana Islands', 166, _oc, 10, 64, 27, 'US', '[AKNW]H0'),
      _ctor(
          'Baker and Howland Islands', 20, _oc, -12, 61, 31, 'US', '[AKNW]H1'),
      _ctor('Guam', 103, _oc, 10, 64, 27, 'GU', '[AKNW]H2'),
      _ctor('Johnston Island', 123, _oc, -11, 61, 31, 'US', '[AKNW]H3'),
      _ctor('Midway Islands', 174, _oc, -11, 61, 31, 'US', '[AKNW]H4'),
      _ctor('Palmyra, Jarvis Island', 197, _oc, -11, 61, 31, 'US', '[AKNW]H5'),
      _ctor('Hawaii', 110, _oc, -10, 61, 31, 'US', '[AKNW]H[67]', [
        _ctor('Kure Atoll', 138, _oc, -11, 61, 31, 'US', '[AKNW]H7K'),
      ]),
      _ctor('American Samoa', 9, _oc, -11, 62, 32, 'AS', '[AKNW]H8', [
        _ctor('Swains Island', 515, _oc, -11, 62, 32, 'US', '[AKNW]H8S'),
      ]),
      _ctor('Wake Island', 297, _oc, 12, 65, 31, 'US', '[AKNW]H9'),
      _ctor('Alaska', 6, _na, -8, 1, 1, 'US', '[AKNW]L'),
      _ctor('Navassa Island', 182, _na, -5, 11, 8, 'US', '[KNW]P1'),
      _ctor('US Virgin Islands', 285, _na, -4, 11, 8, 'VI', '[KNW]P2'),
      _ctor('Puerto Rico', 202, _na, -4, 11, 8, 'PR', '[KNW]P[34]'),
      _ctor('Desecheo Island', 43, _na, -4, 11, 8, 'PR', '[KNW]P5'),
    ]),
    _ctor('Norway', 266, _eu, 1, 18, 14, 'NO', 'L[A-N]'),
    _ctor('Argentina', 100, _sa, -3, 14, 13, 'AR', 'A[YZ]|L[2-9O-W]'),
    _ctor('Luxembourg', 254, _eu, 1, 27, 14, 'LU', 'LX'),
    _ctor('Lithuania', 146, _eu, 2, 29, 15, 'LT', 'LY'),
    _ctor('Bulgaria', 212, _eu, 2, 28, 20, 'BG', 'LZ'),
    _ctor('Peru', 136, _sa, -5, 12, 10, 'PE', '4T|O[ABC]'),
    _ctor('Lebanon', 354, _as, 2, 39, 20, 'LB', 'OD'),
    _ctor('Austria', 206, _eu, 1, 28, 15, 'AT', 'OE'),
    _ctor('Finland', 224, _eu, 2, 18, 15, 'FI', 'O[F-J]', [
      _ctor('Aland Islands', 5, _eu, 2, 18, 15, 'AX', 'O[FGH]0'),
      _ctor('Market Reef', 167, _eu, 2, 18, 15, 'AX', 'OH0M|OJ0'),
    ]),
    _ctor('Czech Republic', 503, _eu, 1, 28, 15, 'CZ', 'O[KL]'),
    _ctor('Slovak Republic', 504, _eu, 1, 28, 15, 'SK', 'OM'),
    _ctor('Belgium', 209, _eu, 1, 27, 14, 'BE', 'O[N-T]'),
    _ctor('Denmark', 221, _eu, 1, 18, 14, 'DK', '5[PQ]|O[UVWZ]|XP'),
    _ctor('Greenland', 237, _na, -3, 5, 40, 'GL', 'OX'),
    _ctor('Faroe Islands', 222, _eu, 0, 18, 14, 'FO', 'OY'),
    _ctor('Papua New Guinea', 163, _oc, 10, 51, 28, 'PG', 'P2'),
    _ctor('Aruba', 91, _sa, -4, 11, 9, 'AW', 'P4'),
    _ctor('Democratic People\'s Rep. of Korea', 344, _as, 9, 44, 25, 'KP',
        'HM|P[5-9]'),
    _ctor('Netherlands', 263, _eu, 1, 27, 14, 'NL', 'P[A-I]'),
    _ctor('Curacao', 517, _sa, -4, 11, 9, 'CW', 'PJ2'),
    _ctor('Bonaire', 520, _sa, 0, 11, 9, 'BQ1', 'PJ4'),
    _ctor('Saba, St Eustatius', 519, _na, -4, 11, 8, 'AN', 'PJ[56]'),
    _ctor('St. Maarten', 518, _na, 0, 11, 8, 'SX', 'PJ7'),
    _ctor('Brazil', 108, _sa, -3, 12, 11, 'BR', 'P[P-Y]|Z[V-Z]', [
      // TODO
      _ctor('Fernando de Noronha', 56, _sa, -2, 13, 11, 'BR',
          r'Z[XYZ]0F|P[QUXY]0F|PY0$_s\/F\b'),
      _ctor('St Peter & St Paul Rocks', 253, _sa, -2, 13, 11, 'BR',
          r'Z[XYZ]0S|P[QUXY]0S|PY0$_s\/S\b'),
      _ctor('Trindade and Martim Vaz Island', 273, _sa, -2, 15, 11, 'BR',
          r'Z[XYZ]0T|P[QUXY]0T|PY0$_s\/T\b'),
    ]),
    _ctor('Suriname', 140, _sa, -4, 12, 9, 'SR', 'PZ'),
    _ctor('Western Sahara', 302, _af, 0, 46, 33, 'EH', 'S0'),
    _ctor('Bangladesh', 305, _as, 6, 41, 22, 'BD', 'S[23]'),
    _ctor('Slovenia', 499, _eu, 1, 28, 15, 'SI', 'S5'),
    _ctor('Seychelles', 379, _af, 4, 53, 39, 'SC', 'S7'),
    _ctor('Sao Tome & Principe', 219, _af, 0, 47, 36, 'ST', 'S9'),
    _ctor('Sweden', 284, _eu, 1, 18, 14, 'SE', '[78]S|S[A-M]'),
    _ctor('Poland', 269, _eu, 1, 28, 15, 'PL', '3Z|HF|S[N-R]'),
    _ctor('Sudan', 466, _af, 2, 48, 34, 'SD', '6[TU]|ST'),
    _ctor('Egypt', 478, _af, 2, 38, 34, 'EG', '6[AB]|SU'),
    _ctor('Greece', 236, _eu, 2, 28, 20, 'GR', 'J4|S[V-Z]', [
      _ctor('Mt Athos', 180, _eu, 2, 28, 20, 'GR', r'SV$_s\/A\b|SY'),
      _ctor('Dodecanese', 45, _eu, 2, 28, 20, 'GR', 'J45|S[VWX]5'),
      _ctor('Crete', 40, _eu, 2, 28, 20, 'GR', 'J49|S[VWX]9'),
    ]),
    _ctor('Tuvalu', 282, _oc, 12, 65, 31, 'TV', 'T2'),
    _ctor('West Kiribati (Gilbert Is.)', 301, _oc, 12, 65, 31, 'KI', 'T30'),
    _ctor('Central Kiribati (British Phoenix Is.)', 31, _oc, 12, 62, 31, 'KI',
        'T31'),
    _ctor('East Kiribati (Line Is.)', 48, _oc, 12, 61, 31, 'KI', 'T32'),
    _ctor('Banaba Island (Ocean I.)', 490, _oc, 12, 65, 31, 'KI', 'T33'),
    _ctor('Somalia', 232, _af, 3, 48, 37, 'SO', '6O|T5'),
    _ctor('San Marino', 278, _eu, 1, 28, 15, 'SM', 'T7'),
    _ctor('Palau', 22, _oc, 10, 64, 27, 'PW', 'T8'),
    _ctor('Turkey', 390, _as, 2, 39, 20, 'TR', 'T[ABC]|YM'),
    _ctor('Iceland', 242, _eu, 0, 17, 40, 'IS', 'TF'),
    _ctor('Guatemala', 76, _na, -6, 11, 7, 'GT', 'T[DG]'),
    _ctor('Costa Rica', 308, _na, -6, 11, 7, 'CR', 'T[EI]', [
      _ctor('Cocos Island', 37, _na, -6, 11, 7, 'CR', 'TI9'),
    ]),
    _ctor('Cameroon', 406, _af, 1, 47, 36, 'CM', 'TJ'),
    _ctor('Corsica', 214, _eu, 1, 28, 15, 'FR', 'TK'),
    _ctor('Central African Republic', 408, _af, 1, 47, 36, 'CF', 'TL'),
    _ctor('Congo', 412, _af, 1, 52, 36, 'CG', 'TN'),
    _ctor('Gabon', 420, _af, 1, 52, 36, 'GA', 'TR'),
    _ctor('Chad', 410, _af, 1, 47, 36, 'TD', 'TT'),
    _ctor('Ivory Coast', 428, _af, 0, 46, 35, 'CI', 'TU'),
    _ctor('Benin', 416, _af, 0, 46, 35, 'BJ', 'TY'),
    _ctor('Mali', 442, _af, 0, 46, 35, 'ML', 'TZ'),
    _ctor('European Russia', 54, _eu, 3, 19, 16, 'RU',
        '(R[A-Z]?|U[A-I]?)[13-7]', [
      _ctor('Franz Josef Land', 61, _eu, 3, 75, 40, 'RU', r'R1($_s\/F\b|F)'),
    ]),
    _ctor('Kaliningrad', 126, _eu, 2, 29, 15, 'RU', '(U[A-I]?|R[A-Z]?)2'),
    _ctor('Asiatic Russia', 15, _as, 7, 20, 16, 'RU', '(U[A-I]?|R[A-Z]?)[089]'),
    _ctor('Uzbekistan', 292, _as, 6, 30, 17, 'UZ', 'U[J-M]'),
    _ctor('Kazakhstan', 130, _as, 6, 29, 17, 'KZ', 'U[N-Q]'),
    _ctor('Ukraine', 288, _eu, 2, 29, 16, 'UA', 'E[MNO]|U[R-Z]'),
    _ctor('Antigua and Barbuda', 94, _na, -4, 11, 8, 'AG', 'V2'),
    _ctor('Belize', 66, _na, -6, 11, 7, 'BZ', 'V3'),
    _ctor('St Kitts and Nevis', 249, _na, -4, 11, 8, 'KN', 'V4'),
    _ctor('Namibia', 464, _af, 2, 57, 38, 'NA', 'V5'),
    _ctor('Micronesia', 173, _oc, 11, 65, 27, 'FM', 'V6'),
    _ctor('Marshall Islands', 168, _oc, 12, 65, 31, 'MH', 'V7'),
    _ctor('Brunei', 345, _oc, 8, 54, 28, 'BN', 'V8'),
    _ctor('Canada', 1, _na, -5, 2, 1, 'CA', 'C[F-KYZ]|V[A-GOXY]|X[J-O]', [
      _ctor('Sable Island', 211, _na, -5, 9, 5, 'CA', 'CY0'),
      _ctor('St Paul Island', 252, _na, -5, 9, 5, 'CA', 'CY9'),
    ]),
    _ctor('Australia', 150, _oc, 10, 55, 29, 'AU', 'AX|V[H-NZ]', [
      // TODO
      _ctor('Heard Islands', 111, _af, 5, 68, 39, 'AU', r'VK0$_s\/H\b'),
      _ctor('Macquarie Island', 153, _oc, 11, 60, 30, 'AU', r'VK0$_s\/M\b'),
      _ctor('Cocos-Keeling Islands', 38, _oc, 7, 54, 29, 'CC',
          r'VK9($_s\/Y\b|[KNZ]?C)'),
      _ctor('Lord Howe Island', 147, _oc, 10, 60, 30, 'AU',
          r'VK9($_s\/H\b|[KNZ]?L)'),
      _ctor(
          'Mellish Reef', 171, _oc, 10, 55, 30, 'AU', r'VK9($_s\/Z\b|[KNZ]?M)'),
      _ctor('Norfolk Island', 189, _oc, 12, 60, 32, 'NF',
          r'VK9($_s\/N\b|[KNZ]?N)'),
      _ctor('Willis Island', 303, _oc, 10, 55, 30, 'AU',
          r'VK9($_s\/W\b|[KNZ]?W)'),
      _ctor('Christmas Island', 35, _oc, 7, 54, 29, 'CX',
          r'VK9($_s\/X\b|[KNZ]?X)'),
    ]),
    _ctor('Hong Kong', 321, _as, 8, 44, 24, 'HK', 'VR|VS6'),
    _ctor('India', 324, _as, 6, 41, 22, 'IN', '8[T-Y]|[AV][T-W]', [
      _ctor('Andaman and Nicobar Islands', 11, _as, 6, 49, 26, 'IN',
          '[8A][TUVW]4|VU4'),
      _ctor(
          'Lakshadweep Islands', 142, _as, 6, 41, 22, 'IN', '[8A][TUVW]7|VU7'),
    ]),
    _ctor('Mexico', 50, _na, -6, 10, 6, 'MX', '4[ABC]|6[D-J]|X[A-I]', [
      _ctor('Revillagigedo Islands', 204, _na, -7, 10, 6, 'MX', 'X[A-I]4'),
    ]),
    _ctor('Burkina Faso', 480, _af, 0, 46, 35, 'BF', 'XT'),
    _ctor('Cambodia', 312, _as, 8, 49, 26, 'KH', 'XU'),
    _ctor('Laos', 143, _as, 7, 49, 26, 'LA', 'XW'),
    _ctor('Macao', 152, _as, 8, 44, 24, 'MO', 'XX9'),
    _ctor('Myanmar (Burma)', 309, _as, 7, 49, 26, 'MM', 'X[YZ]'),
    _ctor('Afghanistan', 3, _as, 5, 40, 21, 'AF', 'T6|YA'),
    _ctor('Indonesia', 327, _oc, 8, 51, 28, 'ID', '[78][A-I]|JZ|P[K-O]|Y[B-H]'),
    _ctor('Iraq', 333, _as, 3, 39, 21, 'IQ', 'HN|YI'),
    _ctor('Vanuatu', 158, _oc, 11, 56, 32, 'VU', 'YJ'),
    _ctor('Syria', 384, _as, 2, 39, 20, 'SY', '6C|YK'),
    _ctor('Latvia', 145, _eu, 2, 29, 15, 'LV', 'YL'),
    _ctor('Nicaragua', 86, _na, -6, 11, 7, 'NI', 'H[67T]|YN'),
    _ctor('Romania', 275, _eu, 2, 28, 20, 'RO', 'Y[O-R]'),
    _ctor('El Salvador', 74, _na, -6, 11, 7, 'SV', 'HU|YS'),
    _ctor('Serbia', 296, _eu, 1, 28, 15, 'RS', 'Y[TU]'),
    _ctor('Venezuela', 148, _sa, -4, 12, 9, 'VE', '4M|Y[V-Y]', [
      _ctor('Aves Island', 17, _na, -4, 11, 8, 'VE', 'Y[VX]0'),
    ]),
    _ctor('Zimbabwe', 452, _af, 2, 53, 38, 'ZW', 'Z2'),
    _ctor('North Macedonia', 502, _eu, 1, 28, 15, 'MK', 'Z3'),
    _ctor('Republic of Kosovo', 522, _eu, 1, 28, 15, 'ZK', 'Z6'),
    _ctor('South Sudan', 521, _af, 0, 0, 0, 'SS', 'Z8'),
    _ctor('Albania', 7, _eu, 1, 28, 15, 'AL', 'ZA'),
    _ctor('Gibraltar', 233, _eu, 1, 37, 14, 'GI', 'ZB'),
    _ctor('Cyprus SBA', 283, _as, 2, 39, 20, 'CY', 'ZC'),
    _ctor('Tokelau Islands', 270, _oc, -11, 62, 31, 'TK', 'ZK3'),
    _ctor('New Zealand', 170, _oc, 12, 60, 32, 'NZ', 'Z[LM]', [
      _ctor('Chatham Islands', 34, _oc, 13, 60, 32, 'NZ', 'Z[LM]7'),
      _ctor('Kermadec Islands', 133, _oc, 12, 60, 32, 'NZ', 'Z[LM]8'),
      _ctor('New Zealand Subantarctic Islands', 16, _oc, 12, 60, 32, 'NZ',
          'Z[LM]9'),
    ]),
    _ctor('Paraguay', 132, _sa, -4, 14, 11, 'PY', 'ZP'),
    _ctor('South Africa', 462, _af, 2, 57, 38, 'ZA', 'S8|Z[R-U]', [
      _ctor('Prince Edward and Marion Island', 201, _af, 3, 57, 38, 'ZA',
          'VY[29]|ZS[28]'),
    ]),
  ];
}
