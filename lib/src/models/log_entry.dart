import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'band.dart';
part 'mode.dart';

class LogEntry extends Equatable {
  static final _dateFormat = DateFormat('yyyyMMdd');
  static final _timeFormat = DateFormat('HHmm');

  final String callsign;
  final String? operator;
  final DateTime timeOn;
  final DateTime timeOff;
  final int frequency;
  final Band? band;
  final int rxFrequency;
  final Band? rxBand;
  final Mode mode; // TODO Submode
  final int? power;
  final String rstSent;
  final String rstRecieved;
  final String name;
  final String notes;

  LogEntry({
    required this.callsign,
    this.operator,
    required DateTime timeOn,
    DateTime? timeOff,
    required this.frequency,
    Band? band,
    int? frequencyRx,
    Band? bandRx,
    required this.mode,
    this.power,
    required this.rstSent,
    required this.rstRecieved,
    this.name = '',
    this.notes = '',
  })  : timeOn = timeOn.toUtc(),
        timeOff = (timeOff ?? timeOn).toUtc(),
        rxFrequency = frequencyRx ?? frequency,
        band = band ?? BandUtil.getBand(frequency),
        rxBand = bandRx ?? BandUtil.getBand(frequencyRx ?? frequency);

  bool get isSplit => frequency != rxFrequency || band != rxBand;

  @override
  List<Object?> get props => [
        callsign,
        operator,
        timeOn,
        timeOff,
        frequency,
        band,
        rxFrequency,
        rxBand,
        mode,
        power,
        rstSent,
        rstRecieved,
        name,
        notes,
      ];

  Map<String, String> toAdiMap() => {
        'call': callsign,
        if (operator != null) 'operator': operator!,
        'freq': '${frequency / 1000000}',
        if (band != null) 'band': band!.name,
        'freq_rx': '${rxFrequency / 1000000}',
        if (rxBand != null) 'band_rx': band!.name,
        'mode': mode.name,
        'qso_date': _dateFormat.format(timeOn),
        'time_on': _timeFormat.format(timeOn),
        'qso_date_off': _dateFormat.format(timeOff),
        'time_off': _timeFormat.format(timeOff),
        'rst_sent': rstSent,
        'rst_rcvd': rstRecieved,
        if (name.isNotEmpty) 'name': name,
        if (notes.isNotEmpty) 'notes': notes,
      };

  factory LogEntry.fromAdiMap(Map<String, String> adi) {
    final date = adi['qso_date']!;
    final time = adi['time_on']!;
    final dateOff = adi['qso_date_off'] ?? date;
    final timeOff = adi['time_off'] ?? time;

    return LogEntry(
      callsign: adi['call']!,
      operator: adi['operator'],
      frequency: (double.parse(adi['freq']!) * 1000000).toInt(),
      band: BandUtil.tryParse(adi['band']),
      frequencyRx: adi['freq_rx'] != null
          ? (double.parse(adi['freq_rx']!) * 1000000).toInt()
          : null,
      bandRx: BandUtil.tryParse(adi['band_rx']),
      timeOn: DateFormat('yyyyMMddHHmm').parseStrict('$date$time'),
      timeOff: DateFormat('yyyyMMddHHmm').parseStrict('$dateOff$timeOff'),
      mode: ModeUtil.tryParse(adi['mode']!)!,
      power: adi['tx_pwr'] != null ? int.parse(adi['tx_pwr']!) : null,
      rstSent: adi['rst_sent']!,
      rstRecieved: adi['rst_rcvd']!,
      name: adi['name'] ?? '',
      notes: adi['notes'] ?? '',
    );
  }
}
