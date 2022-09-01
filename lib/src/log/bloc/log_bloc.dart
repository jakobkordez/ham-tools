import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/log_entry.dart';
import '../../repository/repository.dart';
import '../../utils/log_entry_list_util.dart';

part 'log_event.dart';
part 'log_state.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  static const _limit = 60;

  LogBloc(Repository repository) : super(const LogState()) {
    on<LogRefreshed>((event, emit) async {
      try {
        final count = await repository.getLogEntriesCount();
        final log = await repository.getLogEntries(limit: _limit);

        emit(LogState(
          status: LogStatus.success,
          hasReachedLast: log.length >= count,
          count: count,
          logEntries: log,
        ));

        if (event.to != null) add(LogFetched(0, event.to!));
      } catch (e) {
        debugPrint(e.toString());
        emit(state.copyWith(status: LogStatus.failure));
      }
    });

    on<LogFetched>((event, emit) async {
      if (event.to <= state.logEntries.length) return;

      try {
        final newLog = List.of(state.logEntries);

        while (event.to > newLog.length) {
          final last = newLog.isEmpty ? null : newLog.last;

          final log = await repository.getLogEntries(
            limit: _limit,
            cursorId: last?.id,
            cursorDate: last?.timeOn,
          );
          if (log.isEmpty) break;
          newLog.addAll(log);
        }

        emit(state.copyWith(
          status: LogStatus.success,
          hasReachedLast: newLog.length >= state.count,
          logEntries: newLog,
        ));
      } catch (e) {
        debugPrint(e.toString());
        emit(state.copyWith(status: LogStatus.failure));
      }
    });

    on<LogEntryAdded>((event, emit) async {
      final entry = await repository.addLogEntry(event.entry);
      final newLog = List.of(state.logEntries)..insertByTime(entry);
      emit(state.copyWith(
        status: LogStatus.success,
        logEntries: newLog,
        count: state.count + 1,
      ));
    });

    add(const LogRefreshed());
  }
}
