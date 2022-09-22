// ignore_for_file: avoid_print

import 'dart:io';

import 'package:ham_tools/src/utils/adif.dart';

void main(List<String> args) {
  if (args.length < 2) {
    print('Usage: merge_adi.dart <output file> <...input files>');
    return;
  }

  final output = File(args.first);
  final inputs = args.skip(1).map((path) => File(path)).toList();

  print('Merging: ${args.skip(1).join(', ')}\nInto: ${output.path}');
  print('Press Y to continue, any other key to abort');
  final r = stdin.readLineSync();
  if (r != 'Y') {
    print('Aborted');
    return;
  }

  final entries = <Map<String, String>>[];
  for (final f in inputs) {
    entries.addAll(Adif.decodeAdi(f.readAsStringSync()));
  }

  output.writeAsStringSync(Adif.encodeAdi(entries, pretty: true));
}
