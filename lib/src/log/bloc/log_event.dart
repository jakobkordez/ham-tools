part of 'log_bloc.dart';

abstract class LogEvent extends Equatable {
  const LogEvent();

  @override
  List<Object?> get props => [];
}

class LogAddQsoStream extends LogEvent {
  final QsoStream stream;

  const LogAddQsoStream(this.stream);

  @override
  List<Object?> get props => [stream];
}

class LogFetched extends LogEvent {
  final int from;
  final int to;

  const LogFetched(this.from, this.to);

  @override
  List<Object?> get props => [from, to];
}

class LogRefreshed extends LogEvent {
  final int? to;

  const LogRefreshed([this.to]);

  @override
  List<Object?> get props => [to];
}

class LogEntryAdded extends LogEvent {
  final LogEntry entry;

  const LogEntryAdded(this.entry);

  @override
  List<Object?> get props => [entry];
}
