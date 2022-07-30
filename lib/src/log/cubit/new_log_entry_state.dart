part of 'new_log_entry_cubit.dart';

class NewLogEntryState extends Equatable {
  final bool clean;

  final bool hasTimeOff;
  final bool autoTime;
  final String dateOn;
  final String timeOn;
  final String dateOff;
  final String timeOff;

  final bool split;
  final String frequency;
  final Mode mode;
  final SubMode? subMode;
  final String frequencyRx;
  final String power;

  final String callsign;
  final String rstSent;
  final String rstRcvd;

  late final Band? band =
      BandUtil.getBand(NewLogEntryCubit.tryParseFreq(frequency) ?? -1);
  late final Band? bandRx =
      BandUtil.getBand(NewLogEntryCubit.tryParseFreq(frequencyRx) ?? -1);

  factory NewLogEntryState({
    bool autoTime = true,
    DateTime? timeOn,
    DateTime? timeOff,
    int? frequency,
    Mode? mode,
    SubMode? subMode,
    int? frequencyRx,
    int? power,
    String? callsign,
    String? rstSent,
    String? rstRcvd,
  }) {
    frequency ??= Band.hf40m.lowerBound;
    mode ??= Mode.ssb;
    timeOn = (timeOn ?? DateTime.now()).toUtc();
    timeOff = timeOff?.toUtc();
    callsign ??= '';
    rstSent ??= '';
    rstRcvd ??= '';

    String df(DateTime dt) => LogEntry.dateFormat.format(dt);
    String tf(DateTime dt) => LogEntry.timeFormat.format(dt);
    String ff(double freq) => LogEntry.freqFormat.format(freq);

    return NewLogEntryState._(
      clean: true,
      hasTimeOff: timeOff != null,
      autoTime: autoTime,
      dateOn: df(timeOn),
      timeOn: tf(timeOn),
      dateOff: df(timeOff ?? timeOn),
      timeOff: tf(timeOff ?? timeOn),
      split: frequencyRx != null && frequency != frequencyRx,
      frequency: ff(frequency / 1000000),
      mode: mode,
      subMode: subMode,
      frequencyRx: ff((frequencyRx ?? frequency) / 1000000),
      power: '${power ?? ''}',
      callsign: callsign,
      rstSent: rstSent,
      rstRcvd: rstRcvd,
    );
  }

  NewLogEntryState._({
    required this.clean,
    required this.hasTimeOff,
    required this.autoTime,
    required this.dateOn,
    required this.timeOn,
    required this.dateOff,
    required this.timeOff,
    required this.split,
    required this.frequency,
    required this.mode,
    required this.subMode,
    required this.frequencyRx,
    required this.power,
    required this.callsign,
    required this.rstSent,
    required this.rstRcvd,
  });

  NewLogEntryState copyWith({
    bool? clean,
    bool? autoTime,
    bool? hasTimeOff,
    String? dateOn,
    String? timeOn,
    String? dateOff,
    String? timeOff,
    bool? split,
    String? frequency,
    String? frequencyRx,
    String? power,
    String? callsign,
    String? rstSent,
    String? rstRcvd,
  }) {
    final newSplit = split ?? this.split;
    final newFreq = frequency ?? this.frequency;

    return NewLogEntryState._(
      clean: clean ?? false,
      hasTimeOff: hasTimeOff ?? this.hasTimeOff,
      autoTime: autoTime ?? this.autoTime,
      dateOn: dateOn ?? this.dateOn,
      timeOn: timeOn ?? this.timeOn,
      dateOff: dateOff ?? this.dateOff,
      timeOff: timeOff ?? this.timeOff,
      split: newSplit,
      frequency: newFreq,
      mode: mode,
      subMode: subMode,
      frequencyRx: newSplit ? (frequencyRx ?? this.frequencyRx) : newFreq,
      power: power ?? this.power,
      callsign: callsign ?? this.callsign,
      rstSent: rstSent ?? this.rstSent,
      rstRcvd: rstRcvd ?? this.rstRcvd,
    );
  }

  NewLogEntryState copyWithMode({
    Mode? mode,
    required SubMode? subMode,
  }) =>
      NewLogEntryState._(
        clean: false,
        mode: mode ?? this.mode,
        subMode: subMode,
        hasTimeOff: hasTimeOff,
        autoTime: autoTime,
        dateOn: dateOn,
        timeOn: timeOn,
        dateOff: dateOff,
        timeOff: timeOff,
        split: split,
        frequency: frequency,
        frequencyRx: frequencyRx,
        power: power,
        callsign: callsign,
        rstSent: rstSent,
        rstRcvd: rstRcvd,
      );

  @override
  List<Object?> get props => [
        clean,
        hasTimeOff,
        autoTime,
        dateOn,
        timeOn,
        dateOff,
        timeOff,
        split,
        frequency,
        mode,
        subMode,
        frequencyRx,
        power,
        callsign,
        rstSent,
        rstRcvd,
      ];

  LogEntry asLogEntry() => LogEntry(
        callsign: callsign,
        timeOn: DateTime.parse('${dateOn}T${timeOn}Z'),
        timeOff: DateTime.parse('${dateOff}T${timeOff}Z'),
        mode: mode,
        subMode: subMode,
        rstSent: rstSent,
        rstReceived: rstRcvd,
        frequency: NewLogEntryCubit.tryParseFreq(frequency),
        frequencyRx: NewLogEntryCubit.tryParseFreq(frequencyRx),
        power: int.tryParse(power),
      );
}
