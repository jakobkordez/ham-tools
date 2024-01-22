import '../log_entry.dart';

abstract class QsoStream {
  Stream<LogEntry> get stream;

  void dispose();
}
