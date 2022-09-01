import '../models/log_entry.dart';
import '../models/profile.dart';
import '../models/server/dto/create_profile_dto.dart';

abstract class Repository {
  Future<List<LogEntry>> getLogEntries({
    bool? all,
    String? cursorId,
    DateTime? cursorDate,
    int? limit,
  });

  Future<int> getLogEntriesCount({bool? all});

  Future<LogEntry> addLogEntry(LogEntry entry);

  Future<LogEntry?> getLastLogEntry();

  Future<List<Profile>> getProfiles();

  Future<Profile> addProfile(CreateProfileDto profile);

  Future<void> deleteProfile(String id);
}
