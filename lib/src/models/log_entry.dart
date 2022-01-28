import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import 'band.dart';
import 'mode.dart';

class LogEntry extends Equatable {
  final String callsign;
  final DateTime timeOn;
  final DateTime timeOff;
  final int frequency;
  final Band? band;
  final int rxFrequency;
  final Band? rxBand;
  final Mode mode; // TODO Submode
  final int power;
  final String rstSent;
  final String rstRecieved;
  final String name;
  final String note;

  LogEntry({
    required this.callsign,
    required this.timeOn,
    DateTime? timeOff,
    required this.frequency,
    Band? band,
    int? frequencyRx,
    Band? bandRx,
    required this.mode,
    required this.power,
    required this.rstSent,
    required this.rstRecieved,
    this.name = '',
    this.note = '',
  })  : timeOff = timeOff ?? timeOn,
        rxFrequency = frequencyRx ?? frequency,
        band = band ?? BandUtil.getBand(frequency),
        rxBand = bandRx ?? BandUtil.getBand(frequencyRx ?? frequency);

  bool get isSplit => frequency != rxFrequency || band != rxBand;

  @override
  List<Object?> get props => [
        callsign,
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
        note,
      ];

  Map<String, String> toAdiMap() => {
        'call': callsign,
        'freq': '${frequency / 1000000}',
        if (band != null) 'band': band!.name,
        'freq_rx': '${rxFrequency / 1000000}',
        if (rxBand != null) 'band_rx': band!.name,
        'mode': mode.name,
        'qso_date': DateFormat('yyyyMMdd').format(timeOn.toUtc()),
        'time_on': DateFormat('HHmm').format(timeOn.toUtc()),
      };
}
