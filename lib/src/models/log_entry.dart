import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../utils/adif.dart';

part 'band.dart';
part 'mode.dart';

class LogEntry extends Equatable {
  static final dateFormat = DateFormat('yyyy-MM-dd');
  static final timeFormat = DateFormat('HHmm');
  static final freqFormat = NumberFormat(r'#.000#');

  /// The contacted station's Callsign
  final String callsign;

  /// The logging operator's callsign
  /// - if [stationCall] is absent, [operatorCall] shall be treated as both the
  /// logging station's callsign and the logging operator's callsign
  final String? operatorCall;

  /// The logging station's callsign (the callsign used over the air)
  /// - if [stationCall] is absent, [operatorCall] shall be treated as both the
  /// logging station's callsign and the logging operator's callsign
  final String? stationCall;

  final DateTime timeOn;
  final DateTime timeOff;
  final int frequency;
  final int frequencyRx;
  final Mode mode;
  final SubMode? subMode;
  final int? power;
  final String rstSent;
  final String rstReceived;

  /// The contacted station's grid square
  final String? gridsquare;

  /// The contacted station's operator's name
  final String name;
  final String comment;

  // Contest fields
  /// Contest ID
  final String? contestId;

  /// Contest serial number received
  final int? srx;

  /// Contest serial number sent
  final int? stx;

  /// Contest information received
  final String? srxString;

  /// Contest information sent
  final String? stxString;

  // TODO Fields: CHECK, CLASS, PRECEDENCE

  LogEntry({
    required String callsign,
    this.operatorCall,
    this.stationCall,
    required DateTime timeOn,
    DateTime? timeOff,
    int? frequency,
    Band? band,
    int? frequencyRx,
    Band? bandRx,
    required this.mode,
    this.subMode,
    int? power,
    required this.rstSent,
    required this.rstReceived,
    this.gridsquare,
    this.name = '',
    this.comment = '',
    this.contestId,
    this.srx,
    this.stx,
    this.srxString,
    this.stxString,
  })  : assert(frequency != null || band != null),
        callsign = callsign.toUpperCase(),
        timeOn = timeOn.toUtc(),
        timeOff = (timeOff ?? timeOn).toUtc(),
        frequency = frequency ?? band!.lowerBound,
        frequencyRx =
            frequencyRx ?? bandRx?.lowerBound ?? frequency ?? band!.lowerBound,
        power = power?.isNegative == true ? null : power;

  bool get isSplit => frequency != frequencyRx || band != bandRx;

  String get dateOnString => dateFormat.format(timeOn);
  String get timeOnString => timeFormat.format(timeOn);
  String get dateOffString => dateFormat.format(timeOff);
  String get timeOffString => timeFormat.format(timeOff);

  String get freqMhz => freqFormat.format(frequency / 1000000);
  String get freqRxMhz => freqFormat.format(frequencyRx / 1000000);

  Band? get band => BandUtil.getBand(frequency);
  Band? get bandRx => BandUtil.getBand(frequencyRx);

  @override
  List<Object?> get props => [
        callsign,
        operatorCall,
        stationCall,
        timeOn,
        timeOff,
        frequency,
        frequencyRx,
        mode,
        subMode,
        power,
        rstSent,
        rstReceived,
        gridsquare,
        name,
        comment,
        contestId,
        srx,
        stx,
        srxString,
        stxString,
      ];

  Map<String, String> toAdiMap() => {
        'CALL': callsign,
        'FREQ': '${frequency / 1000000}',
        if (band != null) 'BAND': band!.name,
        'MODE': mode.name,
        if (subMode != null) 'SUBMODE': subMode!.name,
        'QSO_DATE': Adif.dateFormat.format(timeOn),
        'TIME_ON': Adif.timeFormat.format(timeOn),
        if (operatorCall != null) 'OPERATOR': operatorCall!,
        if (stationCall != null) 'STATION_CALLSIGN': stationCall!,
        if (frequencyRx != frequency) 'FREQ_RX': '${frequencyRx / 1000000}',
        if (bandRx != band) 'BAND_RX': bandRx!.name,
        if (timeOff.compareTo(timeOn) != 0)
          'QSO_DATE_OFF': Adif.dateFormat.format(timeOff),
        if (timeOff.compareTo(timeOn) != 0)
          'TIME_OFF': Adif.timeFormat.format(timeOff),
        if (rstSent.isNotEmpty) 'RST_SENT': rstSent,
        if (rstReceived.isNotEmpty) 'RST_RCVD': rstReceived,
        if (gridsquare?.isNotEmpty == true) 'GRIDSQUARE': gridsquare!,
        if (power != null) 'TX_PWR': '$power',
        if (name.isNotEmpty) 'NAME': name,
        if (comment.isNotEmpty) 'COMMENT': comment,
        if (contestId != null) 'CONTEST_ID': contestId!,
        if (srx != null) 'SRX': '$srx',
        if (stx != null) 'STX': '$stx',
        if (srxString != null) 'SRX_STRING': srxString!,
        if (stxString != null) 'STX_STRING': stxString!,
      };

  factory LogEntry.fromAdiMap(Map<String, String> adi) {
    adi = <String, String>{
      for (final kv in adi.entries) kv.key.toUpperCase(): kv.value
    };

    final date = adi['QSO_DATE']!;
    final time = adi['TIME_ON']!;
    final dateOff = adi['QSO_DATE_OFF'] ?? date;
    final timeOff = adi['TIME_OFF'] ?? time;

    return LogEntry(
      callsign: adi['CALL']!.toUpperCase(),
      operatorCall: adi['OPERATOR'],
      stationCall: adi['STATION_CALLSIGN'],
      frequency: adi['FREQ'] != null
          ? (double.parse(adi['FREQ']!) * 1000000).toInt()
          : null,
      band: BandUtil.tryParse(adi['BAND']),
      frequencyRx: adi['FREQ_RX'] != null
          ? (double.parse(adi['FREQ_RX']!) * 1000000).toInt()
          : null,
      bandRx: BandUtil.tryParse(adi['BAND_RX']),
      timeOn: DateTime.parse('${date}T${time}Z'),
      timeOff: DateTime.parse('${dateOff}T${timeOff}Z'),
      mode: ModeUtil.tryParse(adi['MODE']!)!,
      subMode: SubModeUtil.tryParse(adi['SUBMODE']),
      power: adi['TX_PWR'] != null ? int.parse(adi['TX_PWR']!) : null,
      rstSent: adi['RST_SENT'] ?? '',
      rstReceived: adi['RST_RCVD'] ?? '',
      gridsquare: adi['GRIDSQUARE'],
      name: adi['NAME'] ?? '',
      comment: adi['COMMENT'] ?? '',
      contestId: adi['CONTEST_ID'],
      srx: adi['SRX'] != null ? int.parse(adi['SRX']!) : null,
      stx: adi['STX'] != null ? int.parse(adi['STX']!) : null,
      srxString: adi['SRX_STRING'],
      stxString: adi['STX_STRING'],
    );
  }
}
