import 'dart:convert';

import 'package:ham_tools/src/models/log_entry.dart';
import 'package:ham_tools/src/utils/adif.dart';
import 'package:http/http.dart' show Client;
import 'package:intl/intl.dart';

class LotwRepository {
  static const _baseUrl = 'lotw.arrl.org';
  static const _reportPath = '/lotwuser/lotwreport.adi';
  static const _contentType = 'application/x-arrl-adif';
  static final _dateFormat = DateFormat('yyyy-MM-dd');

  final Client client;

  LotwRepository({Client? httpClient}) : client = httpClient ?? Client();

  /// Gets QSO's from LOTW
  ///
  /// If [endDate] is omitted, [DateTime.now] is used
  Future<List<LogEntry>> getReport({
    required String username,
    required String password,
    bool qslOnly = false,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    endDate = (endDate ?? DateTime.now()).toUtc();
    startDate = startDate?.toUtc();

    final queryParams = <String, String>{
      'login': username,
      'password': password,
      'qso_query': '1',
      'qso_qsl': qslOnly ? 'yes' : 'no',
      if (startDate != null) 'qso_startdate': _dateFormat.format(startDate),
      'qso_enddate': _dateFormat.format(endDate),
    };

    final res = await client.get(Uri.https(_baseUrl, _reportPath, queryParams));

    if (res.statusCode != 200 ||
        res.headers['Content-Type']?.startsWith('$_contentType;') != true) {
      throw Exception('Request failed');
    }

    return Adif.decodeAdi(res.body).map((e) => LogEntry.fromAdiMap(e)).toList();
  }
}
