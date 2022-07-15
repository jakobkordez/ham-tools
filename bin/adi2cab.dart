// ignore_for_file: avoid_print

import 'dart:io';

import 'package:ham_tools/src/utils/adif.dart';
import 'package:ham_tools/src/utils/cabrillo/cabrillo.dart';

void main(List<String> args) {
  if (args.length != 2) return print('Usage: adi.dart <file> <out_file>');
  final file = File(args[0]).readAsStringSync();
  final entries = Adif.decodeAdi(file);

  final qsos = entries
      .map((e) => CabrilloQsoData(
            frequency: '${(double.parse(e['freq']!) * 1000).round()}',
            mode: _encodeMode(e['mode']!),
            date: _convertDate(e['qso_date']!),
            time: e['time_on']!,
            callsignSent: e['station_callsign']!,
            exchangeSent: [e['rst_sent']!, e['stx_string']!],
            callsignRecieved: e['call']!,
            exchangeRecieved: [e['rst_rcvd']!, e['srx_string']!],
          ))
      .toList();

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
