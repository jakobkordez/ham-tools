import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ham_tools/src/models/log_entry.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';

import 'repository.dart';

class LocalRepository implements Repository {
  final LocalStorage _storage;

  LocalRepository._(this._storage);

  static Future<LocalRepository> init() async {
    String? path;
    if (!kIsWeb) {
      var pathd = await getApplicationDocumentsDirectory();
      pathd = Directory(pathd.path + '/HamTools');
      if (!await pathd.exists()) await pathd.create(recursive: true);
      path = pathd.path;
    }
    return LocalRepository._(LocalStorage('qso_log.json', path));
  }

  @override
  Future<void> addLogEntry(LogEntry entry) async {
    if (!(await _storage.ready)) throw Exception('Storage error');

    await _storage.setItem(
      'qsos',
      ((_storage.getItem('qsos') as List?) ?? [])..add(entry.toAdiMap()),
    );

    await _storage.setItem('last_qso', entry.toAdiMap());
  }

  @override
  Future<List<LogEntry>> getLogEntries(
      {DateTime? after, DateTime? before}) async {
    if (!(await _storage.ready)) throw Exception('Storage error');

    return ((_storage.getItem('qsos') as List?)
            ?.cast<Map<String, dynamic>>()
            .map((e) => e.map((key, value) => MapEntry(key, value.toString())))
            .map((e) => LogEntry.fromAdiMap(e))
            .toList()
          ?..sort((a, b) => b.timeOn.compareTo(a.timeOn))) ??
        [];
  }

  @override
  Future<LogEntry?> getLastLogEntry() async {
    if (!(await _storage.ready)) throw Exception('Storage error');

    final last = (_storage.getItem('last_qso') as Map?)?.cast<String, String>();
    if (last == null) return null;
    return LogEntry.fromAdiMap(last);
  }
}
