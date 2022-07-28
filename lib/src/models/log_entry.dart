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

  final String callsign;
  final String? operatorCall;
  final DateTime timeOn;
  final DateTime timeOff;
  final int frequency;
  final int frequencyRx;
  final Mode mode;
  final SubMode? subMode;
  final int? power;
  final String rstSent;
  final String rstReceived;
  final String name;
  final String notes;

  LogEntry({
    required String callsign,
    this.operatorCall,
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
    this.name = '',
    this.notes = '',
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
        timeOn,
        timeOff,
        frequency,
        frequencyRx,
        mode,
        subMode,
        power,
        rstSent,
        rstReceived,
        name,
        notes,
      ];

  Map<String, String> toAdiMap() => {
        'call': callsign,
        'freq': '${frequency / 1000000}',
        'mode': mode.name,
        if (subMode != null) 'submode': subMode!.name,
        'qso_date': Adif.dateFormat.format(timeOn),
        'time_on': Adif.timeFormat.format(timeOn),
        if (operatorCall != null) 'operator': operatorCall!,
        if (frequencyRx != frequency) 'freq_rx': '${frequencyRx / 1000000}',
        if (timeOff.compareTo(timeOn) != 0)
          'qso_date_off': Adif.dateFormat.format(timeOff),
        if (timeOff.compareTo(timeOn) != 0)
          'time_off': Adif.timeFormat.format(timeOff),
        if (rstSent.isNotEmpty) 'rst_sent': rstSent,
        if (rstReceived.isNotEmpty) 'rst_rcvd': rstReceived,
        if (name.isNotEmpty) 'name': name,
        if (notes.isNotEmpty) 'notes': notes,
      };

  factory LogEntry.fromAdiMap(Map<String, String> adi) {
    adi = <String, String>{
      for (final kv in adi.entries) kv.key.toLowerCase(): kv.value
    };

    final date = adi['qso_date']!;
    final time = adi['time_on']!;
    final dateOff = adi['qso_date_off'] ?? date;
    final timeOff = adi['time_off'] ?? time;

    return LogEntry(
      callsign: adi['call']!.toUpperCase(),
      operatorCall: adi['operator'],
      frequency: adi['freq'] != null
          ? (double.parse(adi['freq']!) * 1000000).toInt()
          : null,
      band: BandUtil.tryParse(adi['band']),
      frequencyRx: adi['freq_rx'] != null
          ? (double.parse(adi['freq_rx']!) * 1000000).toInt()
          : null,
      bandRx: BandUtil.tryParse(adi['band_rx']),
      timeOn: DateTime.parse('${date}T${time}Z'),
      timeOff: DateTime.parse('${dateOff}T${timeOff}Z'),
      mode: ModeUtil.tryParse(adi['mode']!)!,
      subMode: SubModeUtil.tryParse(adi['submode']),
      power: adi['tx_pwr'] != null ? int.parse(adi['tx_pwr']!) : null,
      rstSent: adi['rst_sent'] ?? '',
      rstReceived: adi['rst_rcvd'] ?? '',
      name: adi['name'] ?? '',
      notes: adi['notes'] ?? '',
    );
  }
}
