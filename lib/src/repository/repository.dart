import '../models/log_entry.dart';
import '../models/profile.dart';
import '../models/server/dto/create_profile_dto.dart';

abstract class Repository {
  Future<List<LogEntry>> getLogEntries({DateTime? after, DateTime? before});

  Future<void> addLogEntry(LogEntry entry);

  Future<LogEntry?> getLastLogEntry();

  Future<List<Profile>> getProfiles();

  Future<void> addProfile(CreateProfileDto profile);

  Future<void> deleteProfile(String id);
}
