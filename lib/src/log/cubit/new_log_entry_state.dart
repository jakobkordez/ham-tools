part of 'new_log_entry_cubit.dart';

class NewLogEntryState extends Equatable {
  final bool clean;

  final bool hasTimeOff;
  final bool autoTime;
  final DateInput dateOn;
  final TimeInput timeOn;
  final DateInput dateOff;
  final TimeInput timeOff;

  final bool split;
  final FrequencyInput frequency;
  final Mode mode;
  final SubMode? subMode;
  final FrequencyInput frequencyRx;
  final String power;

  final String callsign;
  final String rstSent;
  final String rstRcvd;

  late final Band? band =
      BandUtil.getBand(NewLogEntryCubit.tryParseFreq(frequency.value) ?? -1);
  late final Band? bandRx =
      BandUtil.getBand(NewLogEntryCubit.tryParseFreq(frequencyRx.value) ?? -1);

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

    return NewLogEntryState._(
      clean: true,
      hasTimeOff: timeOff != null,
      autoTime: autoTime,
      dateOn: DateInput.pure(timeOn),
      timeOn: TimeInput.pure(timeOn),
      dateOff: DateInput.pure(timeOff ?? timeOn),
      timeOff: TimeInput.pure(timeOff ?? timeOn),
      split: frequencyRx != null && frequency != frequencyRx,
      frequency: FrequencyInput.pure(frequency),
      mode: mode,
      subMode: subMode,
      frequencyRx: FrequencyInput.pure(frequencyRx ?? frequency),
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
    DateInput? dateOn,
    TimeInput? timeOn,
    DateInput? dateOff,
    TimeInput? timeOff,
    bool? split,
    FrequencyInput? frequency,
    FrequencyInput? frequencyRx,
    String? power,
    String? callsign,
    String? rstSent,
    String? rstRcvd,
  }) {
    final newSplit = split ?? this.split;
    final newFreq = frequency ?? this.frequency;

    final newHasTimeOff = hasTimeOff ?? this.hasTimeOff;
    final newDateOn = dateOn ?? this.dateOn;
    final newTimeOn = timeOn ?? this.timeOn;

    return NewLogEntryState._(
      clean: clean ?? false,
      hasTimeOff: newHasTimeOff,
      autoTime: autoTime ?? this.autoTime,
      dateOn: newDateOn,
      timeOn: newTimeOn,
      dateOff: newHasTimeOff ? (dateOff ?? this.dateOff) : newDateOn,
      timeOff: newHasTimeOff ? (timeOff ?? this.timeOff) : newTimeOn,
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
        timeOn: DateTime.parse('${dateOn.value}T${timeOn.value}Z'),
        timeOff: DateTime.parse('${dateOff.value}T${timeOff.value}Z'),
        mode: mode,
        subMode: subMode,
        rstSent: rstSent,
        rstReceived: rstRcvd,
        frequency: NewLogEntryCubit.tryParseFreq(frequency.value),
        frequencyRx: NewLogEntryCubit.tryParseFreq(frequencyRx.value),
        power: int.tryParse(power),
      );
}
