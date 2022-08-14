import 'dart:math';

import '../models/log_entry.dart';
import '../models/profile.dart';
import '../models/server/dto/create_profile_dto.dart';
import 'repository.dart';

class MockRepository implements Repository {
  final List<LogEntry> _log;

  MockRepository([List<LogEntry>? log])
      : _log = log ??
            List.generate(
                50,
                (i) => LogEntry(
                      callsign: _genCallsign(),
                      timeOn: DateTime.now().subtract(Duration(minutes: i)),
                      frequency: 7005000,
                      mode: Mode.cw,
                      power: 100,
                      rstSent: '599',
                      rstReceived: '599',
                    )).toList();

  @override
  Future<List<LogEntry>> getLogEntries(
          {DateTime? after, DateTime? before}) async =>
      _log
          .where((e) =>
              (after?.isBefore(e.timeOn) ?? true) &&
              (before?.isAfter(e.timeOn) ?? true))
          .toList();

  static String _genCallsign() {
    final rnd = Random();
    String rL() => String.fromCharCode(65 + rnd.nextInt(26));
    String rN() => String.fromCharCode(48 + rnd.nextInt(10));
    String ret = '${rL()}${rN()}';
    for (int i = rnd.nextInt(3); i >= 0; --i) {
      ret += rL();
    }
    return ret;
  }

  @override
  Future<void> addLogEntry(LogEntry entry) async {
    final i = _log.indexWhere((e) => e.timeOn.isBefore(entry.timeOn));
    _log.insert(i, entry);
  }

  @override
  Future<LogEntry?> getLastLogEntry() async {
    if (_log.isEmpty) return null;
    return _log.first;
  }

  final List<Profile> _profiles = [
    const Profile(
      profileName: 'Default',
      callsign: 'S52KJ',
      name: 'Jakob K',
      dxcc: 499,
      cqZone: 15,
      ituZone: 28,
      gridsquare: 'JN76',
    ),
  ];

  @override
  Future<void> addProfile(CreateProfileDto profile) async {
    final lastId =
        _profiles.isEmpty ? 0 : (int.tryParse(_profiles.last.id ?? '') ?? 0);

    _profiles.add(Profile(
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
    ));
  }

  @override
  Future<void> deleteProfile(String id) async {
    _profiles.removeWhere((p) => p.id == id);
  }

  @override
  Future<List<Profile>> getProfiles() => Future(() => _profiles);
}
