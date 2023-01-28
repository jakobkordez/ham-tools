// ignore_for_file: avoid_print

import 'dart:io';

import 'package:ham_tools/src/models/log_entry.dart';
import 'package:ham_tools/src/qsl/qsl_csv_gen.dart';
import 'package:ham_tools/src/utils/adif.dart';

const qsoCount = 3;

void main(List<String> args) {
  if (args.length != 2) {
    print('Usage: adi_qsl_csv.dart <input> <output>');
    return;
  }

  print('Reading: ${args.first}');
  final ent = Adif.decodeAdi(File(args.first).readAsStringSync())
      .map((e) => LogEntry.fromAdiMap(e))
      .toList();
  print(
      '${ent.length} QSO\'s, ${Set.of(ent.map((e) => e.callsign)).length} unique callsigns');
  stdout.write('Callsigns (seperated with ,): ');
  final calls = stdin.readLineSync()!.split(',');
  final filtered = ent.where((e) => calls.contains(e.callsign)).toList();
  print('Found ${filtered.length} entries');

  final out = generateQslCsv(filtered, qsoCount: qsoCount);

  print('\n$out\n');
  File(args.last).writeAsStringSync(out);
}
