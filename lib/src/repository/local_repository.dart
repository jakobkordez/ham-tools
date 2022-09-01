import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';

import '../models/log_entry.dart';
import '../models/profile.dart';
import '../models/server/dto/create_profile_dto.dart';
import '../models/server/server_settings.dart';
import '../utils/log_entry_list_util.dart';
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
  Future<LogEntry> addLogEntry(LogEntry entry) async {
    if (!(await _storage.ready)) throw Exception('Storage error');

    await _storage.setItem(
      'qsos',
      ((_storage.getItem('qsos') as List?) ?? [])..add(entry.toAdiMap()),
    );

    await _storage.setItem('last_qso', entry.toAdiMap());
    return entry;
  }

  @override
  Future<int> getLogEntriesCount({bool? all}) async {
    if (!(await _storage.ready)) throw Exception('Storage error');

    return (_storage.getItem('qsos') as List?)?.length ?? 0;
  }

  @override
  Future<List<LogEntry>> getLogEntries({
    bool? all,
    String? cursorId,
    DateTime? cursorDate,
    int? limit,
  }) async {
    if (!(await _storage.ready)) throw Exception('Storage error');

    var t = (_storage.getItem('qsos') as List?)
        ?.map((e) => LogEntry.fromAdiMap((e as Map).cast()))
        .toList();
    if (t == null) return [];

    t.sortByTime();

    Iterable<LogEntry> s = t;
    if (cursorId != null) s = s.where((e) => e.id.compareTo(cursorId) < 0);
    if (cursorDate != null) s = s.where((e) => e.timeOn.isBefore(cursorDate));
    if (limit != null) s = s.take(limit);
    return s.toList();
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

  @override
  Future<Profile> addProfile(CreateProfileDto profile) async {
    if (!(await _storage.ready)) throw Exception('Storage error');

    final profiles = (_storage.getItem('profiles') as List?)
            ?.map((e) => Profile.fromJson(e))
            .toList() ??
        [];

    final lastId =
        profiles.isEmpty ? 0 : (int.tryParse(profiles.last.id ?? '') ?? 0);

    final p = Profile(
      id: '${lastId + 1}',
      profileName: profile.profileName,
      callsign: profile.callsign,
      dxcc: profile.dxcc,
      cqZone: profile.cqZone,
      ituZone: profile.ituZone,
      name: profile.name,
      gridsquare: profile.gridsquare,
      qth: profile.qth,
      state: profile.state,
      country: profile.country,
    );

    profiles.add(p);

    await _storage.setItem(
      'profiles',
      ((_storage.getItem('profiles') as List?) ?? [])..add(profile.toJson()),
    );

    return p;
  }

  @override
  Future<void> deleteProfile(String id) async {
    if (!(await _storage.ready)) throw Exception('Storage error');

    final profiles = (_storage.getItem('profiles') as List?)
            ?.map((e) => Profile.fromJson(e))
            .toList() ??
        [];

    profiles.removeWhere((e) => e.id == id);

    await _storage.setItem('profiles', profiles);
  }

  @override
  Future<List<Profile>> getProfiles() async {
    if (!(await _storage.ready)) throw Exception('Storage error');

    return (_storage.getItem('profiles') as List?)
            ?.map((e) => Profile.fromJson((e)))
            .toList() ??
        [];
  }
}
