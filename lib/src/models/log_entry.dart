import 'dart:math';

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

  // Server data
  final String id;
  final String ownerId;
  final DateTime? createdAt;

  /// The contacted station's Callsign
  final String callsign;

  /// The logging operator's callsign
  /// - if [stationCall] is absent, [operatorCall] shall be treated as both the
  /// logging station's callsign and the logging operator's callsign
  final String operatorCall;

  /// The logging station's callsign (the callsign used over the air)
  /// - if [stationCall] is absent, [operatorCall] shall be treated as both the
  /// logging station's callsign and the logging operator's callsign
  final String stationCall;

  final DateTime timeOn;
  final DateTime timeOff;
  final int frequency;
  final int frequencyRx;
  final Mode mode;
  final SubMode? subMode;
  final int power;
  final String rstSent;
  final String rstReceived;

  /// The contacted station's grid square
  final String gridsquare;

  /// The contacted station's operator's name
  final String name;
  final String comment;

  // SOTA
  final String sotaRef;
  final String mySotaRef;

  // Contest fields
  /// Contest ID
  final String contestId;

  /// Contest serial number received
  final int srx;

  /// Contest serial number sent
  final int stx;

  /// Contest information received
  final String srxString;

  /// Contest information sent
  final String stxString;

  // TODO Contest Fields: CHECK, CLASS, PRECEDENCE

  // MY_? fields
  final String myCity;
  final String myCountry;
  final int myCqZone;
  final int myDxcc;
  final String myGridsquare;
  final int myItuZone;
  final String myName;
  final String myState;

  LogEntry({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    required String callsign,
    String? operatorCall,
    String? stationCall,
    required DateTime timeOn,
    DateTime? timeOff,
    int? frequency,
    Band? band,
    int? frequencyRx,
    Band? bandRx,
    required Mode mode,
    SubMode? subMode,
    int? power,
    String? rstSent,
    String? rstReceived,
    String? gridsquare,
    String? name,
    String? comment,
    String? sotaRef,
    String? mySotaRef,
    String? contestId,
    int? srx,
    int? stx,
    String? srxString,
    String? stxString,
    String? myCity,
    String? myCountry,
    int? myCqZone,
    int? myDxcc,
    String? myGridsquare,
    int? myItuZone,
    String? myName,
    String? myState,
  }) : this._raw(
          id: id ?? '',
          ownerId: ownerId ?? '',
          createdAt: createdAt,
          callsign: callsign.toUpperCase(),
          operatorCall: operatorCall ?? '',
          stationCall: stationCall ?? '',
          timeOn: timeOn.toUtc(),
          timeOff: (timeOff ?? timeOn).toUtc(),
          frequency: frequency ?? band!.lowerBound,
          frequencyRx: frequencyRx ??
              bandRx?.lowerBound ??
              frequency ??
              band!.lowerBound,
          mode: mode,
          subMode: subMode,
          power: max(0, power ?? 0),
          rstSent: rstSent ?? '',
          rstReceived: rstReceived ?? '',
          gridsquare: gridsquare ?? '',
          name: name ?? '',
          comment: comment ?? '',
          sotaRef: sotaRef ?? '',
          mySotaRef: mySotaRef ?? '',
          contestId: contestId ?? '',
          srx: max(0, srx ?? 0),
          stx: max(0, stx ?? 0),
          srxString: srxString ?? '',
          stxString: stxString ?? '',
          myCity: myCity ?? '',
          myCountry: myCountry ?? '',
          myCqZone: myCqZone ?? -1,
          myDxcc: myDxcc ?? -1,
          myGridsquare: myGridsquare ?? '',
          myItuZone: myItuZone ?? -1,
          myName: myName ?? '',
          myState: myState ?? '',
        );

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
        id,
        ownerId,
        createdAt,
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
        sotaRef,
        mySotaRef,
        contestId,
        srx,
        stx,
        srxString,
        stxString,
        myCity,
        myCountry,
        myCqZone,
        myDxcc,
        myGridsquare,
        myItuZone,
        myName,
        myState,
      ];

  Map<String, String> toAdiMap() => {
        'CALL': callsign,
        'FREQ': '${frequency / 1000000}',
        if (band != null) 'BAND': band!.name,
        'MODE': mode.name,
        if (subMode != null) 'SUBMODE': subMode!.name,
        'QSO_DATE': Adif.dateFormat.format(timeOn),
        'TIME_ON': Adif.timeFormat.format(timeOn),
        if (operatorCall.isNotEmpty) 'OPERATOR': operatorCall,
        if (stationCall.isNotEmpty) 'STATION_CALLSIGN': stationCall,
        if (frequencyRx != frequency) 'FREQ_RX': '${frequencyRx / 1000000}',
        if (bandRx != band) 'BAND_RX': bandRx!.name,
        if (timeOff.compareTo(timeOn) != 0)
          'QSO_DATE_OFF': Adif.dateFormat.format(timeOff),
        if (timeOff.compareTo(timeOn) != 0)
          'TIME_OFF': Adif.timeFormat.format(timeOff),
        if (rstSent.isNotEmpty == true) 'RST_SENT': rstSent,
        if (rstReceived.isNotEmpty == true) 'RST_RCVD': rstReceived,
        if (gridsquare.isNotEmpty == true) 'GRIDSQUARE': gridsquare,
        if (power > 0) 'TX_PWR': '$power',
        if (name.isNotEmpty == true) 'NAME': name,
        if (comment.isNotEmpty == true) 'COMMENT': comment,
        if (sotaRef.isNotEmpty == true) 'SOTA_REF': sotaRef,
        if (mySotaRef.isNotEmpty == true) 'MY_SOTA_REF': mySotaRef,
        if (contestId.isNotEmpty) 'CONTEST_ID': contestId,
        if (srx > 0) 'SRX': '$srx',
        if (stx > 0) 'STX': '$stx',
        if (srxString.isNotEmpty) 'SRX_STRING': srxString,
        if (stxString.isNotEmpty) 'STX_STRING': stxString,
        if (myCity.isNotEmpty) 'MY_CITY': myCity,
        if (myCountry.isNotEmpty) 'MY_COUNTRY': myCountry,
        if (myCqZone > 0) 'MY_CQ_ZONE': '$myCqZone',
        if (myDxcc >= 0) 'MY_DXCC': '$myDxcc',
        if (myGridsquare.isNotEmpty) 'MY_GRIDSQUARE': myGridsquare,
        if (myItuZone > 0) 'MY_ITU_ZONE': '$myItuZone',
        if (myName.isNotEmpty) 'MY_NAME': myName,
        if (myState.isNotEmpty) 'MY_STATE': myState,
      };

  factory LogEntry.fromAdiMap(
    Map<String, String> adi, {
    String? id,
    String? ownerId,
    DateTime? createdAt,
  }) {
    adi = <String, String>{
      for (final kv in adi.entries) kv.key.toUpperCase(): kv.value
    };

    final date = adi['QSO_DATE']!;
    final time = adi['TIME_ON']!;
    final dateOff = adi['QSO_DATE_OFF'] ?? date;
    final timeOff = adi['TIME_OFF'] ?? time;

    Mode? mode = ModeUtil.tryParse(adi['MODE']!);
    SubMode? subMode;
    if (mode == null) {
      subMode = SubModeUtil.tryParse(adi['MODE']!);
      if (subMode == null) {
        throw FormatException('Invalid mode: ${adi['MODE']}');
      }
      mode = Mode.values.firstWhere((m) => m.subModes.contains(subMode));
    }
    subMode ??= SubModeUtil.tryParse(adi['SUBMODE']);

    return LogEntry(
      id: id,
      ownerId: ownerId,
      createdAt: createdAt?.toUtc(),
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
      mode: mode,
      subMode: subMode,
      power: adi['TX_PWR'] != null ? int.parse(adi['TX_PWR']!) : null,
      rstSent: adi['RST_SENT'],
      rstReceived: adi['RST_RCVD'],
      gridsquare: adi['GRIDSQUARE'],
      name: adi['NAME'],
      comment: adi['COMMENT'],
      sotaRef: adi['SOTA_REF'],
      mySotaRef: adi['MY_SOTA_REF'],
      contestId: adi['CONTEST_ID'],
      srx: adi['SRX'] != null ? int.parse(adi['SRX']!) : null,
      stx: adi['STX'] != null ? int.parse(adi['STX']!) : null,
      srxString: adi['SRX_STRING'],
      stxString: adi['STX_STRING'],
      myCity: adi['MY_CITY'],
      myCountry: adi['MY_COUNTRY'],
      myCqZone:
          adi['MY_CQ_ZONE'] != null ? int.parse(adi['MY_CQ_ZONE']!) : null,
      myDxcc: adi['MY_DXCC'] != null ? int.parse(adi['MY_DXCC']!) : null,
      myGridsquare: adi['MY_GRIDSQUARE'],
      myItuZone:
          adi['MY_ITU_ZONE'] != null ? int.parse(adi['MY_ITU_ZONE']!) : null,
      myName: adi['MY_NAME'],
      myState: adi['MY_STATE'],
    );
  }

  factory LogEntry.fromJson(Map<String, dynamic> json) => LogEntry.fromAdiMap(
        (json['data'] as Map<String, dynamic>).cast(),
        id: json['_id'],
        ownerId: json['owner'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at']).toUtc()
            : null,
      );

  const LogEntry._raw({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    required this.callsign,
    required this.operatorCall,
    required this.stationCall,
    required this.timeOn,
    required this.timeOff,
    required this.frequency,
    required this.frequencyRx,
    required this.mode,
    required this.subMode,
    required this.power,
    required this.rstSent,
    required this.rstReceived,
    required this.gridsquare,
    required this.name,
    required this.comment,
    required this.sotaRef,
    required this.mySotaRef,
    required this.contestId,
    required this.srx,
    required this.stx,
    required this.srxString,
    required this.stxString,
    required this.myCity,
    required this.myCountry,
    required this.myCqZone,
    required this.myDxcc,
    required this.myGridsquare,
    required this.myItuZone,
    required this.myName,
    required this.myState,
  });

  LogEntry copyWith({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    String? callsign,
    String? operatorCall,
    String? stationCall,
    DateTime? timeOn,
    DateTime? timeOff,
    int? frequency,
    int? frequencyRx,
    Mode? mode,
    int? power,
    String? rstSent,
    String? rstReceived,
    String? gridsquare,
    String? name,
    String? comment,
    String? sotaRef,
    String? mySotaRef,
    String? contestId,
    String? srxString,
    String? stxString,
    int? srx,
    int? stx,
    String? myCity,
    String? myCountry,
    int? myCqZone,
    int? myDxcc,
    String? myGridsquare,
    int? myItuZone,
    String? myName,
    String? myState,
  }) =>
      LogEntry(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        callsign: callsign ?? this.callsign,
        operatorCall: operatorCall ?? this.operatorCall,
        stationCall: stationCall ?? this.stationCall,
        timeOn: timeOn ?? this.timeOn,
        timeOff: timeOff ?? this.timeOff,
        frequency: frequency ?? this.frequency,
        frequencyRx: frequencyRx ?? this.frequencyRx,
        mode: mode ?? this.mode,
        power: power ?? this.power,
        rstSent: rstSent ?? this.rstSent,
        rstReceived: rstReceived ?? this.rstReceived,
        gridsquare: gridsquare ?? this.gridsquare,
        name: name ?? this.name,
        comment: comment ?? this.comment,
        sotaRef: sotaRef ?? this.sotaRef,
        mySotaRef: mySotaRef ?? this.mySotaRef,
        contestId: contestId ?? this.contestId,
        srx: srx ?? this.srx,
        stx: stx ?? this.stx,
        srxString: srxString ?? this.srxString,
        stxString: stxString ?? this.stxString,
        createdAt: createdAt,
        subMode: subMode,
        myCity: myCity ?? this.myCity,
        myCountry: myCountry ?? this.myCountry,
        myCqZone: myCqZone ?? this.myCqZone,
        myDxcc: myDxcc ?? this.myDxcc,
        myGridsquare: myGridsquare ?? this.myGridsquare,
        myItuZone: myItuZone ?? this.myItuZone,
        myName: myName ?? this.myName,
        myState: myState ?? this.myState,
      );
}
