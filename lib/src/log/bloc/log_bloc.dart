import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ham_tools/src/models/log_entry.dart';
import 'package:ham_tools/src/repository/repository.dart';

part 'log_event.dart';
part 'log_state.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  bool _isFetching = false;

  LogBloc(Repository repository) : super(const LogState()) {
    on<LogFetched>(
      (event, emit) async {
        if (_isFetching || state.hasReachedLast) return;

        _isFetching = true;
        try {
          if (state.status == LogStatus.intial) {
            final logEntries = await repository.getLogEntries();
            emit(state.copyWith(
              status: LogStatus.success,
              logEntries: logEntries,
            ));
            _isFetching = false;
            return;
          }

          final logEntries =
              await repository.getLogEntries(skipId: state.logEntries.last.id);

          emit(logEntries.isEmpty
              ? state.copyWith(
                  status: LogStatus.success,
                  hasReachedLast: true,
                )
              : state.copyWith(
                  status: LogStatus.success,
                  logEntries: List.of(state.logEntries)..addAll(logEntries),
                ));
        } catch (e) {
          emit(state.copyWith(status: LogStatus.success));
        } finally {
          _isFetching = false;
        }
      },
    );
  }
}
