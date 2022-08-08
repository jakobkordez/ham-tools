import 'package:collection/collection.dart';
import 'package:dio/dio.dart';

import '../models/log_entry.dart';
import '../utils/adif.dart';

// https://lotw.arrl.org/lotw-help/developer-query-qsos-qsls/
// https://lotw.arrl.org/lotw-help/developer-submit-qsos/
// https://lotw.arrl.org/lotw-help/developer-query-lotw-users/

class LotwClient {
  static const _baseUrl = 'lotw.arrl.org';
  static const _reportPath = '/lotwuser/lotwreport.adi';
  static const _userActivityPath = '/lotw-user-activity.csv';
  static const _contentType = 'application/x-arrl-adif';

  static const _cacheLifetime = Duration(hours: 1);

  final Dio client;

  LotwClient({Dio? dioClient}) : client = dioClient ?? Dio();

  /// Gets QSO's from LOTW
  ///
  /// If [endDate] is omitted, [DateTime.now] is used
  ///
  /// Note that while the user's primary call sign is usually the username,
  /// this is not always the case and should not be assumed.
  ///
  /// - [qslOnly] : If `true`, only QSL records are returned.
  /// - [qslSince] : Returns QSL records received (matched or updated) on or
  ///     after the specified date.
  /// - [qsoRxSince] : Returns QSO records received (uploaded) on or
  ///     after the specified date.
  Future<List<LogEntry>> getReport({
    required String username,
    required String password,
    bool qslOnly = false,
    DateTime? qslSince,
    DateTime? qsoRxSince,
    String? ownCall,
    String? callsign,
    String? mode,
    String? band,
    int? dxcc,
    DateTime? startDate,
    DateTime? endDate,
    bool myDetail = false,
    bool qslDetail = false,
    bool withOwn = false,
  }) async {
    final data = await getRawReports(
      username: username,
      password: password,
      qslOnly: qslOnly,
      qslSince: qslSince,
      qsoRxSince: qsoRxSince,
      ownCall: ownCall,
      callsign: callsign,
      mode: mode,
      band: band,
      dxcc: dxcc,
      startDate: startDate,
      endDate: endDate,
      myDetail: myDetail,
      qslDetail: qslDetail,
      withOwn: withOwn,
    );

    return Adif.decodeAdi(data).map((e) => LogEntry.fromAdiMap(e)).toList();
  }

  Future<String> getRawReports({
    required String username,
    required String password,
    bool qslOnly = false,
    DateTime? qslSince,
    DateTime? qsoRxSince,
    String? ownCall,
    String? callsign,
    String? mode,
    String? band,
    int? dxcc,
    DateTime? startDate,
    DateTime? endDate,
    bool myDetail = false,
    bool qslDetail = false,
    bool withOwn = false,
  }) async {
    qslSince = qslSince?.toUtc();
    qsoRxSince = qsoRxSince?.toUtc();
    endDate = (endDate ?? DateTime.now()).toUtc();
    startDate = startDate?.toUtc();

    final queryParams = <String, String>{
      'login': username,
      'password': password,
      'qso_query': '1',
      'qso_qsl': qslOnly ? 'yes' : 'no',
      if (qslSince != null) 'qso_qslsince': _formatDate(qslSince),
      if (qsoRxSince != null) 'qso_qsorxsince': _formatDate(qsoRxSince),
      if (ownCall != null) 'qso_owncall': ownCall,
      if (callsign != null) 'qso_callsign': callsign,
      if (mode != null) 'qso_mode': mode,
      if (band != null) 'qso_band': band,
      if (dxcc != null) 'qso_dxcc': '$dxcc',
      if (startDate != null) 'qso_startdate': _formatDate(startDate),
      if (startDate != null) 'qso_starttime': _formatTime(startDate),
      'qso_enddate': _formatDate(endDate),
      'qso_endtime': _formatTime(endDate),
      if (myDetail) 'qso_mydetail': 'yes',
      if (qslDetail) 'qso_qsldetail': 'yes',
      if (withOwn) 'qso_withown': 'yes',
    };

    final res = await client
        .get(Uri.https(_baseUrl, _reportPath, queryParams).toString());

    final contentType = res.headers.map.entries
        .firstWhereOrNull((e) => e.key.toLowerCase() == 'content-type')
        ?.value;

    if (res.statusCode != 200 ||
        contentType?.any((e) => e.contains('$_contentType;')) != true) {
      throw Exception('Request failed: ${res.statusCode} ${res.data}');
    }

    return res.data;
  }

  // User activity cache
  Map<String, String>? _userActivityCache;
  DateTime? _userActivityCacheLastUpdated;

  Future<DateTime?> getUserLastUpload(
    String callsign, [
    bool updateCache = false,
  ]) async {
    if (updateCache ||
        (_userActivityCacheLastUpdated
                ?.add(_cacheLifetime)
                .isBefore(DateTime.now()) ??
            true)) {
      final res =
          await client.get(Uri.https(_baseUrl, _userActivityPath).toString());

      if (res.statusCode != 200) {
        throw Exception('Request failed: ${res.statusCode} ${res.data}');
      }

      _userActivityCache =
          Map.fromEntries((res.data as String).trim().split('\n').map((e) {
        final i = e.indexOf(',');
        return MapEntry(e.substring(0, i), e.substring(i + 1));
      }));
      _userActivityCacheLastUpdated = DateTime.now();
    }

    final user = _userActivityCache![callsign];
    if (user == null) return null;

    return DateTime.parse('${user.replaceAll(',', 'T')}Z');
  }

  String _formatDate(DateTime dt) => dt.toIso8601String().substring(0, 10);
  String _formatTime(DateTime dt) => dt.toIso8601String().substring(11, 19);
}
