import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../utils/adif.dart';
import 'qsl_enum.dart';

part 'band.dart';
part 'mode.dart';

class LogEntry extends UnmodifiableMapView<String, String> with EquatableMixin {
  static final dateFormat = DateFormat('yyyy-MM-dd');
  static final timeFormat = DateFormat('HHmm');
  static final freqFormat = NumberFormat(r'#.000#');

  static final invalidDate = DateTime.utc(0);

  // Server data
  final String? id;
  final String? ownerId;
  final DateTime? createdAt;

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
  final String? rstSent;
  final String? rstReceived;

  /// The contacted station's grid square
  final String? gridsquare;

  /// The contacted station's operator's name
  final String? name;

  /// Single line comment of QSO
  final String? comment;

  // SOTA
  final String? sotaRef;
  final String? mySotaRef;

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

  // TODO Contest Fields: CHECK, CLASS, PRECEDENCE

  // MY_? fields
  final String? myCity;
  final String? myCountry;
  final int? myCqZone;
  final int? myDxcc;
  final String? myGridsquare;
  final int? myItuZone;
  final String? myName;
  final String? myState;

  // QSL
  final QslRcvd? qslRcvd;
  final QslSent? qslSent;
  final DateTime? qslRcvdDate;
  final DateTime? qslSentDate;

  LogEntry({
    String? id,
    String? ownerId,
    DateTime? createdAt,
    required String callsign,
    String? operatorCall,
    String? stationCall,
    required DateTime timeOn,
    DateTime? timeOff,
    required int frequency,
    int? frequencyRx,
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
    QslRcvd? qslRcvd,
    QslSent? qslSent,
    DateTime? qslRcvdDate,
    DateTime? qslSentDate,
    Map<String, String>? otherFields,
  }) : this._raw(
          id: id?.emptyToNull,
          ownerId: ownerId?.emptyToNull,
          createdAt: createdAt?.year == 0 ? null : createdAt?.toUtc(),
          callsign: callsign.toUpperCase(),
          operatorCall: operatorCall?.emptyToNull,
          stationCall: stationCall?.emptyToNull,
          timeOn: timeOn.toUtc(),
          timeOff: (timeOff ?? timeOn).toUtc(),
          frequency: frequency,
          frequencyRx: frequencyRx ?? frequency,
          mode: mode,
          subMode: subMode == SubMode.none ? null : subMode,
          power: power?.betweenOrNull(min: 1),
          rstSent: rstSent?.emptyToNull,
          rstReceived: rstReceived?.emptyToNull,
          gridsquare: gridsquare?.emptyToNull,
          name: name?.emptyToNull,
          comment: comment?.emptyToNull,
          sotaRef: sotaRef?.emptyToNull,
          mySotaRef: mySotaRef?.emptyToNull,
          contestId: contestId?.emptyToNull,
          srx: srx?.betweenOrNull(min: 1),
          stx: stx?.betweenOrNull(min: 1),
          srxString: srxString?.emptyToNull,
          stxString: stxString?.emptyToNull,
          myCity: myCity?.emptyToNull,
          myCountry: myCountry?.emptyToNull,
          myCqZone: myCqZone?.betweenOrNull(min: 1),
          myDxcc: myDxcc?.betweenOrNull(min: 0),
          myGridsquare: myGridsquare?.emptyToNull,
          myItuZone: myItuZone?.betweenOrNull(min: 1),
          myName: myName?.emptyToNull,
          myState: myState?.emptyToNull,
          qslRcvd: qslRcvd,
          qslSent: qslSent,
          qslRcvdDate: qslRcvdDate,
          qslSentDate: qslSentDate,
          otherFields: otherFields,
        );

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
        this,
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
        qslRcvd,
        qslSent,
        qslRcvdDate,
        qslSentDate,
      ];

  Map<String, String> toAdiMap() => <String, String?>{
        ...this,
        'CALL': callsign,
        'FREQ': '${frequency / 1000000}',
        'BAND': band?.name,
        'MODE': mode.name,
        'SUBMODE': subMode?.name,
        'QSO_DATE': Adif.dateFormat.format(timeOn),
        'TIME_ON': Adif.timeFormat.format(timeOn),
        'OPERATOR': operatorCall,
        'STATION_CALLSIGN': stationCall,
        'FREQ_RX': frequencyRx != frequency ? '${frequencyRx / 1000000}' : null,
        'BAND_RX': frequencyRx != frequency ? bandRx?.name : null,
        'QSO_DATE_OFF': timeOff.compareTo(timeOn) != 0
            ? Adif.dateFormat.format(timeOff)
            : null,
        'TIME_OFF': timeOff.compareTo(timeOn) != 0
            ? Adif.timeFormat.format(timeOff)
            : null,
        'RST_SENT': rstSent,
        'RST_RCVD': rstReceived,
        'GRIDSQUARE': gridsquare,
        'TX_PWR': power?.toString(),
        'NAME': name,
        'COMMENT': comment,
        'SOTA_REF': sotaRef,
        'MY_SOTA_REF': mySotaRef,
        'CONTEST_ID': contestId,
        'SRX': srx?.toString(),
        'STX': stx?.toString(),
        'SRX_STRING': srxString,
        'STX_STRING': stxString,
        'MY_CITY': myCity,
        'MY_COUNTRY': myCountry,
        'MY_CQ_ZONE': myCqZone?.toString(),
        'MY_DXCC': myDxcc?.toString(),
        'MY_GRIDSQUARE': myGridsquare,
        'MY_ITU_ZONE': myItuZone?.toString(),
        'MY_NAME': myName,
        'MY_STATE': myState,
        'QSL_RCVD': qslRcvd?.name,
        'QSL_SENT': qslSent?.name,
        'QSLRDATE':
            qslRcvdDate != null ? Adif.dateFormat.format(qslRcvdDate!) : null,
        'QSLSDATE':
            qslSentDate != null ? Adif.dateFormat.format(qslSentDate!) : null,
      }.filterNulls();

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
      frequency:
          adi['FREQ']?.tryParseFreq ?? adi['BAND']!.tryParseBand!.lowerBound,
      frequencyRx: adi['FREQ_RX']?.tryParseFreq ??
          adi['BAND_RX']?.tryParseBand!.lowerBound,
      timeOn: DateTime.parse('${date}T${time}Z'),
      timeOff: DateTime.parse('${dateOff}T${timeOff}Z'),
      mode: mode,
      subMode: subMode,
      power: adi['TX_PWR']?.tryParseInt,
      rstSent: adi['RST_SENT'],
      rstReceived: adi['RST_RCVD'],
      gridsquare: adi['GRIDSQUARE'],
      name: adi['NAME'],
      comment: adi['COMMENT'],
      sotaRef: adi['SOTA_REF'],
      mySotaRef: adi['MY_SOTA_REF'],
      contestId: adi['CONTEST_ID'],
      srx: adi['SRX']?.tryParseInt,
      stx: adi['STX']?.tryParseInt,
      srxString: adi['SRX_STRING'],
      stxString: adi['STX_STRING'],
      myCity: adi['MY_CITY'],
      myCountry: adi['MY_COUNTRY'],
      myCqZone: adi['MY_CQ_ZONE']?.tryParseInt,
      myDxcc: adi['MY_DXCC']?.tryParseInt,
      myGridsquare: adi['MY_GRIDSQUARE'],
      myItuZone: adi['MY_ITU_ZONE']?.tryParseInt,
      myName: adi['MY_NAME'],
      myState: adi['MY_STATE'],
      qslRcvd: QslRcvd.fromName(adi['QSL_RCVD']),
      qslSent: QslSent.fromName(adi['QSL_SENT']),
      qslRcvdDate: adi['QSLRDATE']?.tryParseDate,
      qslSentDate: adi['QSLSDATE']?.tryParseDate,
      otherFields: adi,
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

  LogEntry._raw({
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
    required this.qslRcvd,
    required this.qslSent,
    required this.qslRcvdDate,
    required this.qslSentDate,
    required Map<String, String>? otherFields,
  }) : super(Map.unmodifiable(otherFields ?? const <String, String>{}));

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
    QslRcvd? qslRcvd,
    QslSent? qslSent,
    DateTime? qslRcvdDate,
    DateTime? qslSentDate,
    Map<String, String>? otherFields,
  }) =>
      LogEntry(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        createdAt: createdAt ?? this.createdAt,
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
        subMode: subMode ?? this.subMode,
        myCity: myCity ?? this.myCity,
        myCountry: myCountry ?? this.myCountry,
        myCqZone: myCqZone ?? this.myCqZone,
        myDxcc: myDxcc ?? this.myDxcc,
        myGridsquare: myGridsquare ?? this.myGridsquare,
        myItuZone: myItuZone ?? this.myItuZone,
        myName: myName ?? this.myName,
        myState: myState ?? this.myState,
        qslRcvd: qslRcvd ?? this.qslRcvd,
        qslSent: qslSent ?? this.qslSent,
        qslRcvdDate: qslRcvdDate ?? this.qslRcvdDate,
        qslSentDate: qslSentDate ?? this.qslSentDate,
        otherFields: otherFields == null ? this : (copy()..addAll(otherFields)),
      );

  @override
  String toString() =>
      '$dateOnString $timeOnString $callsign ${band?.name ?? '?'} ${subMode?.name ?? mode.name}';
}

extension on String {
  String? get emptyToNull => isNotEmpty ? this : null;

  int? get tryParseInt => int.tryParse(this);

  int? get tryParseFreq {
    final v = double.tryParse(this);
    if (v == null) return null;
    return (v * 1000000).toInt();
  }

  Band? get tryParseBand => BandUtil.tryParse(this);

  DateTime? get tryParseDate => DateTime.tryParse('${this}T00Z');
}

extension on int {
  int? betweenOrNull({int? min, int? max}) {
    if (min != null && this < min) return null;
    if (max != null && this > max) return null;
    return this;
  }
}

extension on Map<String, String> {
  Map<String, String> copy() => Map.of(this);
}

extension on Map<String, String?> {
  Map<String, String> filterNulls() => Map.fromEntries(entries
      .where((e) => e.value != null)
      .map((e) => MapEntry(e.key, e.value as String)));
}
