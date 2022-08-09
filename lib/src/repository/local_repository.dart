import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';

import '../models/log_entry.dart';
import '../models/server/server_settings.dart';
import 'repository.dart';

class LocalRepository implements Repository {
  final LocalStorage _storage;

  LocalRepository._(this._storage);

  static Future<LocalRepository> init() async {
    String? path;
    if (!kIsWeb) {
      var pathd = await getApplicationDocumentsDirectory();
      pathd = Directory('${pathd.path}/HamTools');
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
            ?.map((e) => LogEntry.fromAdiMap((e as Map).cast()))
            .where((e) =>
                (after?.isBefore(e.timeOn) ?? true) &&
                (before?.isAfter(e.timeOn) ?? true))
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

  Future<ServerSettings?> getServerSettings() async {
    if (!(await _storage.ready)) throw Exception('Storage error');

    final json = _storage.getItem('server_settings') as Map?;

    if (json == null) return null;
    return ServerSettings.fromJson(json.cast());
  }

  Future<void> setServerSettings(ServerSettings? settings) async {
    if (!(await _storage.ready)) throw Exception('Storage error');

    if (settings == null) {
      await _storage.deleteItem('server_settings');
    } else {
      await _storage.setItem('server_settings', settings.toJson());
    }
  }
}
