import 'package:equatable/equatable.dart';

class LogEntry extends Equatable {
  final int id;
  final String callsign;
  final DateTime time;
  final int frequency;
  final Mode mode;
  final int power;
  final String qth;
  final String rstS;
  final String rstR;
  final String name;
  final String note;

  const LogEntry({
    required this.id,
    required this.callsign,
    required this.time,
    required this.frequency,
    required this.mode,
    required this.power,
    required this.qth,
    required this.rstS,
    required this.rstR,
    this.name = '',
    this.note = '',
  });

  @override
  List<Object?> get props =>
      [id, callsign, time, frequency, mode, power, qth, rstS, rstR, name, note];
}

enum Mode { cw, lsb, usb, fm, am, digi }

enum Band {
  lf2200,
  mf630m,
  hf80m,
  hf60m,
  hf40m,
  hf30m,
  hf20m,
  hf17m,
  hf15m,
  hf12m,
  hf10m,
  vhf8m,
  vhf6m,
  vhf5m,
  vhf4m,
  vhf2m,
  uhf70cm,
  uhf23cm,
  uhf13cm,
}
