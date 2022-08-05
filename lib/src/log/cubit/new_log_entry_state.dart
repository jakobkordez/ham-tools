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

  final CallsignInput callsign;
  final String rstSent;
  final String rstRcvd;

  // Contest
  final bool showContest;
  // final String contest;
  final String contestSrx;
  final String contestStx;
  final String contestSrxString;
  final String contestStxString;

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
    int? srx,
    int? stx,
    String? srxString,
    String? stxString,
  }) {
    frequency ??= Band.hf40m.lowerBound;
    mode ??= Mode.ssb;
    timeOn = (timeOn ?? DateTime.now()).toUtc();
    timeOff = timeOff?.toUtc();
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
      callsign: callsign == null
          ? CallsignInput.pure()
          : CallsignInput.dirty(callsign),
      rstSent: rstSent,
      rstRcvd: rstRcvd,
      showContest: srx != null ||
          stx != null ||
          srxString?.isNotEmpty == true ||
          stxString?.isNotEmpty == true,
      contestSrx: '${srx ?? ''}',
      contestStx: '${stx ?? ''}',
      contestSrxString: srxString ?? '',
      contestStxString: stxString ?? '',
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
    required this.showContest,
    required this.contestSrx,
    required this.contestStx,
    required this.contestSrxString,
    required this.contestStxString,
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
    CallsignInput? callsign,
    String? rstSent,
    String? rstRcvd,
    bool? showContest,
    String? contestSrx,
    String? contestStx,
    String? contestSrxString,
    String? contestStxString,
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
      showContest: showContest ?? this.showContest,
      contestSrx: contestSrx ?? this.contestSrx,
      contestStx: contestStx ?? this.contestStx,
      contestSrxString: contestSrxString ?? this.contestSrxString,
      contestStxString: contestStxString ?? this.contestStxString,
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
        showContest: showContest,
        contestSrx: contestSrx,
        contestStx: contestStx,
        contestSrxString: contestSrxString,
        contestStxString: contestStxString,
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
        showContest,
        contestSrx,
        contestStx,
        contestSrxString,
        contestStxString,
      ];

  LogEntry asLogEntry() => LogEntry(
        callsign: callsign.value,
        timeOn: DateTime.parse('${dateOn.value}T${timeOn.value}Z'),
        timeOff: DateTime.parse('${dateOff.value}T${timeOff.value}Z'),
        mode: mode,
        subMode: subMode,
        rstSent: rstSent,
        rstReceived: rstRcvd,
        frequency: NewLogEntryCubit.tryParseFreq(frequency.value),
        frequencyRx: NewLogEntryCubit.tryParseFreq(frequencyRx.value),
        power: int.tryParse(power),
        srx: int.tryParse(contestSrx),
        stx: int.tryParse(contestStx),
        srxString: contestSrxString.isEmpty ? null : contestSrxString,
        stxString: contestStxString.isEmpty ? null : contestStxString,
      );
}
