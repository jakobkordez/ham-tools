part of 'log_bloc.dart';

abstract class LogEvent extends Equatable {
  const LogEvent();

  @override
  List<Object?> get props => [];
}

class LogFetched extends LogEvent {}

class LogEntryAdded extends LogEvent {
  final LogEntry entry;

  const LogEntryAdded(this.entry);

  @override
  List<Object?> get props => [entry];
}
