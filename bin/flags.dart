import 'dart:io';

import 'package:ham_tools/src/utils/callsign_util.dart';

const res = '64';
const uri = 'https://static.qrz.com/static/flags-iso/flat/$res/';

Future<void> main(List<String> args) async {
  final path = Platform.script.resolve('../assets/flags/$res').toFilePath();
  final flags = Set.of(getFlags());

  for (final flag in flags) {
    final request = await HttpClient().getUrl(Uri.parse('$uri$flag.png'));
    final response = await request.close();
    await response.pipe(File('$path/$flag.png').openWrite());
  }
}

Iterable<String> getFlags([List<DxccEntity>? dxccs]) sync* {
  dxccs ??= DxccEntity.dxccs;
  for (final e in dxccs) {
    yield e.flag;
    yield* getFlags(e.sub);
  }
}
