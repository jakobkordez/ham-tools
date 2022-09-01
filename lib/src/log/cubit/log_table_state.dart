part of 'log_table_cubit.dart';

class LogTableState extends Equatable {
  final int rowsPerPage;
  final int currentPage;

  const LogTableState({
    this.rowsPerPage = 20,
    this.currentPage = 0,
  });

  LogTableState copyWith({
    int? rowsPerPage,
    int? currentPage,
  }) =>
      LogTableState(
        rowsPerPage: rowsPerPage ?? this.rowsPerPage,
        currentPage: currentPage ?? this.currentPage,
      );

  @override
  List<Object> get props => [rowsPerPage, currentPage];
}

class LogTableDelete extends LogTableState {
  final Set<String> selected;

  const LogTableDelete({
    super.rowsPerPage,
    super.currentPage,
    this.selected = const {},
  });

  @override
  LogTableState copyWith({
    int? rowsPerPage,
    int? currentPage,
    Set<String>? selected,
  }) =>
      LogTableDelete(
        rowsPerPage: rowsPerPage ?? this.rowsPerPage,
        currentPage: currentPage ?? this.currentPage,
        selected: selected ?? this.selected,
      );

  @override
  List<Object> get props => [...super.props, selected];
}
