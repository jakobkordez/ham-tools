// ignore_for_file: avoid_print

import 'dart:io';

import 'package:ham_tools/src/utils/adif.dart';
import 'package:ham_tools/src/utils/cabrillo/cabrillo.dart';

void main(List<String> args) {
  if (args.length != 2) return print('Usage: adi.dart <file> <out_file>');
  final file = File(args[0]).readAsStringSync();
  final entries = Adif.decodeAdi(file);

  final qsos = entries.map((e) {
    e = {for (final ee in e.entries) ee.key.toUpperCase(): ee.value};

    return CabrilloQsoData(
      frequency: '${(double.parse(e['FREQ']!) * 1000).round()}',
      mode: _encodeMode(e['MODE']!),
      date: _convertDate(e['QSO_DATE']!),
      time: e['TIME_ON']!,
      callsignSent: e['STATION_CALLSIGN'] ?? e['OPERATOR']!,
      exchangeSent: [e['RST_SENT']!, e['STX_STRING']!],
      callsignReceived: e['CALL']!,
      exchangeReceived: [e['RST_RCVD']!, e['SRX_STRING']!],
    );
  }).toList()
    ..sort((a, b) {
      if (a.date != b.date) return a.date.compareTo(b.date);
      return a.time.compareTo(b.time);
    });

  final header = CabrilloHeader();
  header.callsign = qsos.first.callsignSent;
  header.operator = CabrilloCategoryOperator.singleOp;
  header.contest = 'KV prvenstvo ZRS';
  header.band = CabrilloCategoryBand.hf80m;
  header.mode = CabrilloCategoryMode.mixed;
  header.power = CabrilloCategoryPower.qrp;
  header.operators = [header.callsign!];
  header.overlay = CabrilloCategoryOverlay.rookie;
  header.claimedScore = 0;
  header.name = 'Jakob Kordež';
  header.address = 'Polhov Gradec 125\n1355 Polhov Gradec';
  header.email = 'jakobkordez1999@gmail.com';

  File(args[1]).writeAsStringSync(
    Cabrillo.encodeCabrillo(qsos, header: header),
  );
}

String _encodeMode(String mode) {
  switch (mode) {
    case 'CW':
      return 'CW';
    case 'SSB':
      return 'PH';
    case 'FM':
      return 'FM';
    case 'RTTY':
      return 'RY';
    default:
      return 'DG';
  }
}

String _convertDate(String d) =>
    '${d.substring(0, 4)}-${d.substring(4, 6)}-${d.substring(6, 8)}';
