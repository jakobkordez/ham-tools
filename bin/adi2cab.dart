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
  }).toList();

  File(args[1]).writeAsStringSync(Cabrillo.encodeCabrillo(qsos));
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
