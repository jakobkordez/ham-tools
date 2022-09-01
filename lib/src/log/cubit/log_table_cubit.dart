import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'log_table_state.dart';

class LogTableCubit extends Cubit<LogTableState> {
  LogTableCubit() : super(const LogTableState());

  void setCountPerPage(int value) => emit(state.copyWith(rowsPerPage: value));

  void setCurrentPage(int value) => emit(state.copyWith(currentPage: value));

  void toggleDeleteMode() {
    final state = this.state;

    if (state is LogTableDelete) {
      return emit(LogTableState(
        rowsPerPage: state.rowsPerPage,
        currentPage: state.currentPage,
      ));
    }

    emit(LogTableDelete(
      rowsPerPage: state.rowsPerPage,
      currentPage: state.currentPage,
    ));
  }

  void setSelected(String id, bool value) {
    final state = this.state;
    if (state is! LogTableDelete) return;
    final s = Set.of(state.selected);
    if (value) {
      s.add(id);
    } else {
      s.remove(id);
    }
    emit(state.copyWith(selected: s));
  }
}
