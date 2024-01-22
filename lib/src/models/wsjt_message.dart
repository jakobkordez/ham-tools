import 'dart:typed_data';

import '../utils/byte_parser.dart';
import 'time.dart';

enum SpecialOperation {
  none,
  naVhf,
  euVhf,
  fieldDay,
  rttyRu,
  wwDigi,
  fox,
  hound
}

abstract class WsjtMessage {
  static const magic = 0xadbccbda;
  static const schema = 2;

  final String id;

  WsjtMessage({required this.id});

  static WsjtMessage parseMessage(Uint8List data) {
    final byteData = ByteParser(ByteData.sublistView(data));

    // Check packet magic number
    final m = byteData.parseUint32();
    if (m != magic) {
      throw Exception('Packet is not speaking the WSJT-X protocol');
    }

    // Get schema
    final sch = byteData.parseUint32();
    if (sch != schema) throw Exception('Got an unexpected schema version');

    final type = byteData.parseUint32();
    switch (type) {
      case 0: // Heartbeat
        return HeartbeatMessage.parse(byteData);
      case 1: // Status
        return StatusMessage.parse(byteData);
      case 2: // Decode
        return DecodeMessage.parse(byteData);
      case 3: // Clear
        return ClearMessage.parse(byteData);
      case 5: // QSO Logged
        return QsoLoggedMessage.parse(byteData);
      case 6: // Close
        return CloseMessage.parse(byteData);
      case 10: // WSPR Decode
        return WsprDecodeMessage.parse(byteData);
      case 12: // Logged ADIF
        return LoggedAdifMessage.parse(byteData);
      default:
        throw UnimplementedError('Message type "$type" not implemented');
    }
  }
}

class HeartbeatMessage extends WsjtMessage {
  final int maximumSchemaNumber;
  final String version;
  final String revision;

  HeartbeatMessage({
    required super.id,
    required this.maximumSchemaNumber,
    required this.version,
    required this.revision,
  });

  factory HeartbeatMessage.parse(ByteParser parser) => HeartbeatMessage(
        id: parser.parseUtf8(),
        maximumSchemaNumber: parser.parseUint32(),
        version: parser.parseUtf8(),
        revision: parser.parseUtf8(),
      );

  @override
  String toString() =>
      '$HeartbeatMessage($id, $maximumSchemaNumber, $version, $revision)';
}

class StatusMessage extends WsjtMessage {
  final int frequency;
  final String mode;
  final String dxCall;
  final String report;
  final String txMode;
  final bool txEnabled;
  final bool transmitting;
  final bool decoding;
  final int rxFrequency;
  final int txFrequency;
  final String deCall;
  final String deGrid;
  final String dxGrid;
  final bool txWatchdog;
  final String subMode;
  final bool fastMode;
  final SpecialOperation specialOperation;
  final int frequencyTolerance;
  final int trPeriod;
  final String configName;
  final String txMessage;

  StatusMessage({
    required super.id,
    required this.frequency,
    required this.mode,
    required this.dxCall,
    required this.report,
    required this.txMode,
    required this.txEnabled,
    required this.transmitting,
    required this.decoding,
    required this.rxFrequency,
    required this.txFrequency,
    required this.deCall,
    required this.deGrid,
    required this.dxGrid,
    required this.txWatchdog,
    required this.subMode,
    required this.fastMode,
    required this.specialOperation,
    required this.frequencyTolerance,
    required this.trPeriod,
    required this.configName,
    required this.txMessage,
  });

  factory StatusMessage.parse(ByteParser parser) => StatusMessage(
        id: parser.parseUtf8(),
        frequency: parser.parseUint64(),
        mode: parser.parseUtf8(),
        dxCall: parser.parseUtf8(),
        report: parser.parseUtf8(),
        txMode: parser.parseUtf8(),
        txEnabled: parser.parseBool(),
        transmitting: parser.parseBool(),
        decoding: parser.parseBool(),
        rxFrequency: parser.parseUint32(),
        txFrequency: parser.parseUint32(),
        deCall: parser.parseUtf8(),
        deGrid: parser.parseUtf8(),
        dxGrid: parser.parseUtf8(),
        txWatchdog: parser.parseBool(),
        subMode: parser.parseUtf8(),
        fastMode: parser.parseBool(),
        specialOperation: SpecialOperation.values[parser.parseUint8()],
        frequencyTolerance: parser.parseUint32(),
        trPeriod: parser.parseUint32(),
        configName: parser.parseUtf8(),
        txMessage: parser.parseUtf8(),
      );

  @override
  String toString() => '$StatusMessage($id, $frequency, $mode)';
}

class DecodeMessage extends WsjtMessage {
  final bool isNew;
  final Time time;
  final int snr;
  final double deltaTime;
  final int deltaFrequency;
  final String mode;
  final String message;
  final bool lowConfidence;
  final bool offAir;

  DecodeMessage({
    required super.id,
    required this.isNew,
    required this.time,
    required this.snr,
    required this.deltaTime,
    required this.deltaFrequency,
    required this.mode,
    required this.message,
    required this.lowConfidence,
    required this.offAir,
  });

  factory DecodeMessage.parse(ByteParser parser) => DecodeMessage(
        id: parser.parseUtf8(),
        isNew: parser.parseBool(),
        time: parser.parseQTime(),
        snr: parser.parseInt32(),
        deltaTime: parser.parseDouble(),
        deltaFrequency: parser.parseUint32(),
        mode: parser.parseUtf8(),
        message: parser.parseUtf8(),
        lowConfidence: parser.parseBool(),
        offAir: parser.parseBool(),
      );

  @override
  String toString() => '$DecodeMessage($id, $isNew, $snr, $message)';
}

class ClearMessage extends WsjtMessage {
  ClearMessage({required super.id});

  factory ClearMessage.parse(ByteParser parser) =>
      ClearMessage(id: parser.parseUtf8());

  @override
  String toString() => '$ClearMessage($id)';
}

class QsoLoggedMessage extends WsjtMessage {
  final DateTime dateTimeOff;
  final String dxCall;
  final String dxGrid;
  final int txFrequency;
  final String mode;
  final String reportSent;
  final String reportReceived;
  final String txPower;
  final String comments;
  final String name;
  final DateTime dateTimeOn;
  final String operatorCall;
  final String myCall;
  final String myGrid;
  final String exchangeSent;
  final String exchangeReceived;
  final String adifPropagationMode;

  QsoLoggedMessage({
    required super.id,
    required this.dateTimeOff,
    required this.dxCall,
    required this.dxGrid,
    required this.txFrequency,
    required this.mode,
    required this.reportSent,
    required this.reportReceived,
    required this.txPower,
    required this.comments,
    required this.name,
    required this.dateTimeOn,
    required this.operatorCall,
    required this.myCall,
    required this.myGrid,
    required this.exchangeSent,
    required this.exchangeReceived,
    required this.adifPropagationMode,
  });

  factory QsoLoggedMessage.parse(ByteParser parser) => QsoLoggedMessage(
        id: parser.parseUtf8(),
        dateTimeOff: parser.parseQDateTime(),
        dxCall: parser.parseUtf8(),
        dxGrid: parser.parseUtf8(),
        txFrequency: parser.parseUint64(),
        mode: parser.parseUtf8(),
        reportSent: parser.parseUtf8(),
        reportReceived: parser.parseUtf8(),
        txPower: parser.parseUtf8(),
        comments: parser.parseUtf8(),
        name: parser.parseUtf8(),
        dateTimeOn: parser.parseQDateTime(),
        operatorCall: parser.parseUtf8(),
        myCall: parser.parseUtf8(),
        myGrid: parser.parseUtf8(),
        exchangeSent: parser.parseUtf8(),
        exchangeReceived: parser.parseUtf8(),
        adifPropagationMode: parser.parseUtf8(),
      );

  @override
  String toString() =>
      '$QsoLoggedMessage($id, $dateTimeOn, $dxCall, $reportSent, $reportReceived)';
}

class CloseMessage extends WsjtMessage {
  CloseMessage({required super.id});

  factory CloseMessage.parse(ByteParser parser) =>
      CloseMessage(id: parser.parseUtf8());

  @override
  String toString() => '$CloseMessage($id)';
}

class WsprDecodeMessage extends WsjtMessage {
  final bool isNew;
  final Time time;
  final int snr;
  final double deltaTime;
  final int frequency;
  final int drift;
  final String callsign;
  final String grid;
  final int power;
  final bool offAir;

  WsprDecodeMessage({
    required super.id,
    required this.isNew,
    required this.time,
    required this.snr,
    required this.deltaTime,
    required this.frequency,
    required this.drift,
    required this.callsign,
    required this.grid,
    required this.power,
    required this.offAir,
  });

  factory WsprDecodeMessage.parse(ByteParser parser) => WsprDecodeMessage(
        id: parser.parseUtf8(),
        isNew: parser.parseBool(),
        time: parser.parseQTime(),
        snr: parser.parseInt32(),
        deltaTime: parser.parseDouble(),
        frequency: parser.parseUint64(),
        drift: parser.parseInt32(),
        callsign: parser.parseUtf8(),
        grid: parser.parseUtf8(),
        power: parser.parseInt32(),
        offAir: parser.parseBool(),
      );

  @override
  String toString() =>
      '$WsprDecodeMessage($id, $isNew, $callsign, $grid, $snr, $frequency)';
}

class LoggedAdifMessage extends WsjtMessage {
  final String adif;

  LoggedAdifMessage({
    required super.id,
    required this.adif,
  });

  factory LoggedAdifMessage.parse(ByteParser parser) => LoggedAdifMessage(
        id: parser.parseUtf8(),
        adif: parser.parseUtf8(),
      );

  @override
  String toString() => '$LoggedAdifMessage($id)';
}
