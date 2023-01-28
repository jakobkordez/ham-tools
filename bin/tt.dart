import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ham_tools/src/models/server/dto/refresh_token_dto.dart';
import 'package:ham_tools/src/repository/server_client.dart';

Future<void> main(List<String> args) async {
  const refreshToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjJlYTFlZWZhMWU5OTU4MGQxMGFlNGU2IiwiaWF0IjoxNjYxNzE4ODkzfQ.tRhEiJ7HMIMlzrP7AZ2r1BmlVcz8Zn9MriwAP-gSPlw';

  final server = ServerClient(Dio());
  final access = await server.refresh(const RefreshTokenDto(refreshToken));

  final res =
      await server.getLogEntries('Bearer ${access.accessToken}', limit: 2);
  print(res);
  for (final e in res) {
    for (final f in e.props) {
      if (f is String && f.contains(' Jakob Kordež')) continue;
      if (f.toString().length != utf8.encode(f.toString()).length) {
        print('${e.id} - ${e.callsign}: "$f"');
      }
    }
  }

  exit(0);
}
