import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ham_tools/src/models/server/dto/create_log_entry_dto.dart';
import 'package:ham_tools/src/models/server/dto/refresh_token_dto.dart';
import 'package:ham_tools/src/repository/server_client.dart';
import 'package:ham_tools/src/utils/adif.dart';

Future<void> main(List<String> args) async {
  const refreshToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjJlYTFlZWZhMWU5OTU4MGQxMGFlNGU2IiwiaWF0IjoxNjYxNzE4ODkzfQ.tRhEiJ7HMIMlzrP7AZ2r1BmlVcz8Zn9MriwAP-gSPlw';

  final server = ServerClient(Dio());
  final access = await server.refresh(const RefreshTokenDto(refreshToken));

  final imports = Adif.decodeAdi(await File(args.single).readAsString());

  const entriesPerRequest = 100;
  for (int i = 0; i < imports.length; i += entriesPerRequest) {
    await server.createLogEntries(
      'Bearer ${access.accessToken}',
      imports
          .skip(i)
          .take(entriesPerRequest)
          .map((e) => CreateLogEntryDto(data: e))
          .toList(),
    );
  }

  // final res = await server.getLogEntries(
  //   'Bearer ${access.accessToken}',
  //   after: DateTime.utc(2022, 2, 1).toIso8601String(),
  //   before: DateTime.utc(2022, 3, 0).toIso8601String(),
  // );
  // print(res
  //     .map((e) =>
  //         '${e.dateOnString} ${e.timeOnString} ${e.callsign.padRight(8)} ${e.freqMhz}')
  //     .join('\n'));
  exit(0);
}
