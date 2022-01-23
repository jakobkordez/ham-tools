part of 'log_bloc.dart';

enum LogStatus { intial, success, failure }

class LogState extends Equatable {
  final LogStatus status;
  final List<LogEntry> logEntries;
  final bool hasReachedLast;

  const LogState({
    this.status = LogStatus.intial,
    this.logEntries = const [],
    this.hasReachedLast = false,
  });

  LogState copyWith({
    LogStatus? status,
    List<LogEntry>? logEntries,
    bool? hasReachedLast,
  }) =>
      LogState(
        status: status ?? this.status,
        logEntries: logEntries ?? this.logEntries,
        hasReachedLast: hasReachedLast ?? this.hasReachedLast,
      );

  @override
  List<Object> get props => [status, logEntries, hasReachedLast];
}
