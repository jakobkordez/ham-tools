import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/lotw_client.dart';
import '../qso_stats.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  StatsCubit() : super(StatsState());

  void parse() {
    if (state.adi.isEmpty) {
      emit(state.copyWith(
        status: StatsStateStatus.error,
        error: 'ADI field is empty',
      ));
      return;
    }

    final stats = QsoStats.parse(state.adi);
    emit(state.copyWith(
      status: StatsStateStatus.loaded,
      qsoStats: stats,
    ));
  }

  void updateAdi(String adi, [bool force = false]) {
    emit(state.copyWith(adi: adi, updateAdi: force));
  }

  void updateLotwUsername(String lotwUsername) {
    emit(state.copyWith(lotwUsername: lotwUsername));
  }

  void updateLotwPassword(String lotwPassword) {
    emit(state.copyWith(lotwPassword: lotwPassword));
  }

  Future<void> fetchLotw() async {
    emit(state.copyWith(status: StatsStateStatus.loading));

    try {
      final lotw = LotwClient();

      final data = await lotw.getRawReports(
        username: state.lotwUsername,
        password: state.lotwPassword,
      );

      final stats = QsoStats.parse(data);
      emit(state.copyWith(
        status: StatsStateStatus.loaded,
        adi: data,
        updateAdi: true,
        qsoStats: stats,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StatsStateStatus.error,
        error: e.toString(),
      ));
    }
  }
}
