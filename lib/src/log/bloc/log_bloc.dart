import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/log_entry.dart';
import '../../repository/repository.dart';

part 'log_event.dart';
part 'log_state.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  LogBloc(Repository repository) : super(const LogState()) {
    on<LogFetched>((event, emit) async {
      final log = await repository.getLogEntries();

      emit(LogState(
        status: LogStatus.success,
        hasReachedLast: true,
        logEntries: log,
      ));
    });

    on<LogEntryAdded>((event, emit) async {
      await repository.addLogEntry(event.entry);

      add(LogFetched());
    });
  }
}
