part of 'log_bloc.dart';

enum LogStatus { intial, success, failure }

class LogState extends Equatable {
  final LogStatus status;
  final int count;
  final List<LogEntry> logEntries;
  final bool hasReachedLast;

  const LogState({
    this.status = LogStatus.intial,
    this.count = 0,
    this.logEntries = const [],
    this.hasReachedLast = false,
  });

  LogState copyWith({
    LogStatus? status,
    int? count,
    List<LogEntry>? logEntries,
    bool? hasReachedLast,
  }) =>
      LogState(
        status: status ?? this.status,
        count: count ?? this.count,
        logEntries: logEntries ?? this.logEntries,
        hasReachedLast: hasReachedLast ?? this.hasReachedLast,
      );

  @override
  List<Object> get props => [status, count, logEntries, hasReachedLast];
}
