import '../models/log_entry.dart';

extension LogEntryList on List<LogEntry> {
  void sortByTime() => sort((a, b) => a.compareTo(b));

  void insertByTime(LogEntry entry) {
    final i = indexWhere((e) => e.compareTo(entry) >= 0);
    if (i == -1) {
      add(entry);
    } else {
      insert(i, entry);
    }
  }
}

extension on LogEntry {
  int compareTo(LogEntry other) {
    final t = other.timeOn.compareTo(timeOn);
    if (t != 0) return t;
    return other.id.compareTo(id);
  }
}
