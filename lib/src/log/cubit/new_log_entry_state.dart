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

  final bool showComment;
  final String comment;

  // SOTA
  final bool showSota;
  final SotaRefInput sotaRef;
  final SotaRefInput mySotaRef;

  // Contest
  final bool showContest;
  // TODO final String contest;
  final String contestSrx;
  final String contestStx;
  final String contestSrxString;
  final String contestStxString;

  // Sender info
  final String stationCallsign;
  final String operatorCallsign;
  final String myName;
  final String myCity;
  final String myState;
  final String myCountry;
  final String myDxcc;
  final String myGridsquare;
  final String myCqZone;
  final String myItuZone;
  // TODO final String myIota;

  late final Band? band =
      BandUtil.getBand(NewLogEntryCubit.tryParseFreq(frequency.value) ?? -1);
  late final Band? bandRx =
      BandUtil.getBand(NewLogEntryCubit.tryParseFreq(frequencyRx.value) ?? -1);

  factory NewLogEntryState.fromLast(LogEntry e) => NewLogEntryState(
        frequency: e.frequency,
        mode: e.mode,
        subMode: e.subMode,
        frequencyRx: e.frequencyRx,
        power: e.power != null && e.power! > 0 ? e.power : null,
        mySotaRef: e.mySotaRef,
        stx: e.stx != null && e.stx! > 0 ? e.stx! + 1 : null,
        stxString: e.stxString,
      );

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
    String? comment,
    String? sotaRef,
    String? mySotaRef,
    int? srx,
    int? stx,
    String? srxString,
    String? stxString,
    Profile? profile,
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
      showComment: comment?.isNotEmpty ?? false,
      comment: comment ?? '',
      showSota: sotaRef?.isNotEmpty == true || mySotaRef?.isNotEmpty == true,
      sotaRef:
          sotaRef == null ? SotaRefInput.pure() : SotaRefInput.dirty(sotaRef),
      mySotaRef: mySotaRef == null
          ? SotaRefInput.pure()
          : SotaRefInput.dirty(mySotaRef),
      showContest: srx != null ||
          stx != null ||
          srxString?.isNotEmpty == true ||
          stxString?.isNotEmpty == true,
      contestSrx: '${srx ?? ''}',
      contestStx: '${stx ?? ''}',
      contestSrxString: srxString ?? '',
      contestStxString: stxString ?? '',
      stationCallsign: profile?.callsign ?? '',
      myCity: profile?.qth ?? '',
      myState: profile?.state ?? '',
      myCountry: profile?.country ?? '',
      myDxcc: '${profile?.dxcc ?? ''}',
      myGridsquare: profile?.gridsquare ?? '',
      myCqZone: '${profile?.cqZone ?? ''}',
      myItuZone: '${profile?.ituZone ?? ''}',
      myName: profile?.name ?? '',
      // TODO Operator
      operatorCallsign: '',
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
    required this.showComment,
    required this.comment,
    required this.showSota,
    required this.sotaRef,
    required this.mySotaRef,
    required this.showContest,
    required this.contestSrx,
    required this.contestStx,
    required this.contestSrxString,
    required this.contestStxString,
    required this.stationCallsign,
    required this.operatorCallsign,
    required this.myName,
    required this.myCity,
    required this.myState,
    required this.myCountry,
    required this.myDxcc,
    required this.myGridsquare,
    required this.myCqZone,
    required this.myItuZone,
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
    bool? showComment,
    String? comment,
    bool? showSota,
    SotaRefInput? sotaRef,
    SotaRefInput? mySotaRef,
    bool? showContest,
    String? contestSrx,
    String? contestStx,
    String? contestSrxString,
    String? contestStxString,
    String? stationCallsign,
    String? operatorCallsign,
    String? myName,
    String? myCity,
    String? myState,
    String? myCountry,
    String? myDxcc,
    String? myGridsquare,
    String? myCqZone,
    String? myItuZone,
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
      showComment: showComment ?? this.showComment,
      comment: comment ?? this.comment,
      showSota: showSota ?? this.showSota,
      sotaRef: sotaRef ?? this.sotaRef,
      mySotaRef: mySotaRef ?? this.mySotaRef,
      showContest: showContest ?? this.showContest,
      contestSrx: contestSrx ?? this.contestSrx,
      contestStx: contestStx ?? this.contestStx,
      contestSrxString: contestSrxString ?? this.contestSrxString,
      contestStxString: contestStxString ?? this.contestStxString,
      stationCallsign: stationCallsign ?? this.stationCallsign,
      operatorCallsign: operatorCallsign ?? this.operatorCallsign,
      myName: myName ?? this.myName,
      myCity: myCity ?? this.myCity,
      myState: myState ?? this.myState,
      myCountry: myCountry ?? this.myCountry,
      myDxcc: myDxcc ?? this.myDxcc,
      myGridsquare: myGridsquare ?? this.myGridsquare,
      myCqZone: myCqZone ?? this.myCqZone,
      myItuZone: myItuZone ?? this.myItuZone,
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
        showComment: showComment,
        comment: comment,
        showSota: showSota,
        sotaRef: sotaRef,
        mySotaRef: mySotaRef,
        showContest: showContest,
        contestSrx: contestSrx,
        contestStx: contestStx,
        contestSrxString: contestSrxString,
        contestStxString: contestStxString,
        stationCallsign: stationCallsign,
        operatorCallsign: operatorCallsign,
        myName: myName,
        myCity: myCity,
        myState: myState,
        myCountry: myCountry,
        myDxcc: myDxcc,
        myGridsquare: myGridsquare,
        myCqZone: myCqZone,
        myItuZone: myItuZone,
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
        showComment,
        comment,
        showSota,
        sotaRef,
        mySotaRef,
        showContest,
        contestSrx,
        contestStx,
        contestSrxString,
        contestStxString,
        stationCallsign,
        operatorCallsign,
        myName,
        myCity,
        myState,
        myCountry,
        myDxcc,
        myGridsquare,
        myCqZone,
        myItuZone,
      ];

  LogEntry asLogEntry() => LogEntry(
        callsign: callsign.value,
        timeOn: DateTime.parse('${dateOn.value}T${timeOn.value}Z'),
        timeOff: DateTime.parse('${dateOff.value}T${timeOff.value}Z'),
        mode: mode,
        subMode: subMode,
        rstSent: rstSent.isNotEmpty ? rstSent : null,
        rstReceived: rstRcvd.isNotEmpty ? rstRcvd : null,
        frequency: NewLogEntryCubit.tryParseFreq(frequency.value)!,
        frequencyRx: NewLogEntryCubit.tryParseFreq(frequencyRx.value),
        power: int.tryParse(power),
        comment: comment.isNotEmpty ? comment : null,
        sotaRef: sotaRef.value.isNotEmpty ? sotaRef.value : null,
        mySotaRef: mySotaRef.value.isNotEmpty ? mySotaRef.value : null,
        srx: int.tryParse(contestSrx),
        stx: int.tryParse(contestStx),
        srxString: contestSrxString.isNotEmpty ? contestSrxString : null,
        stxString: contestStxString.isNotEmpty ? contestStxString : null,
        stationCall: stationCallsign.isNotEmpty ? stationCallsign : null,
        operatorCall: operatorCallsign.isNotEmpty ? operatorCallsign : null,
        myName: myName.isNotEmpty ? myName : null,
        myCity: myCity.isNotEmpty ? myCity : null,
        myState: myState.isNotEmpty ? myState : null,
        myCountry: myCountry.isNotEmpty ? myCountry : null,
        myDxcc: int.tryParse(myDxcc),
        myGridsquare: myGridsquare.isNotEmpty ? myGridsquare : null,
        myCqZone: int.tryParse(myCqZone),
        myItuZone: int.tryParse(myItuZone),
      );
}
