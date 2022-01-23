import 'package:ham_tools/src/models/log_entry.dart';

abstract class Repository {
  Future<List<LogEntry>> getLogEntries({int count, int? skipId});
}
