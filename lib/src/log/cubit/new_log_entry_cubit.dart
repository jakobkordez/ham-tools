import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/log_entry.dart';
import '../bloc/log_bloc.dart';
import '../models/callsign_input.dart';
import '../models/date_input.dart';
import '../models/frequency_input.dart';
import '../models/time_input.dart';

part 'new_log_entry_state.dart';

class NewLogEntryCubit extends Cubit<NewLogEntryState> {
  final LogBloc logBloc;

  NewLogEntryCubit(this.logBloc, [LogEntry? last])
      : super(last == null
            ? NewLogEntryState()
            : NewLogEntryState(
                frequency: last.frequency,
                mode: last.mode,
                subMode: last.subMode,
                frequencyRx: last.frequencyRx,
                power: last.power,
                stx: last.stx != null ? last.stx! + 1 : null,
                stxString: last.stxString,
              ));

  void submit() {
    final e = state.asLogEntry();
    logBloc.add(LogEntryAdded(e));
    emit(NewLogEntryState(
      frequency: e.frequency,
      mode: e.mode,
      subMode: e.subMode,
      frequencyRx: e.frequencyRx,
      power: e.power,
      stx: e.stx != null ? e.stx! + 1 : null,
      stxString: e.stxString,
    ));
  }

  static int? tryParseFreq(String value) {
    if (value.contains('.')) {
      final i = value.indexOf('.');
      value =
          '${value.substring(0, i)}.${value.substring(i).replaceAll('.', '')}';
    }
    final p = double.tryParse(value);
    if (p == null) return null;
    return (p * 1000000).toInt();
  }

  void setAutoTime(bool? value) {
    if (value != true) {
      emit(state.copyWith(autoTime: value));
      return;
    }

    emit(state.copyWith(autoTime: value));

    if (state.hasTimeOff) {
      setTimeOffNow();
    } else {
      setTimeOnNow();
    }
  }

  void setHasTimeOff(bool? value) => emit(state.copyWith(hasTimeOff: value));

  void setTimeOnNow() {
    final now = DateTime.now().toUtc();
    emit(state.copyWith(
      dateOn: DateInput.pure(now),
      timeOn: TimeInput.pure(now),
    ));
  }

  void setTimeOffNow() {
    final now = DateTime.now().toUtc();
    emit(state.copyWith(
      dateOff: DateInput.pure(now),
      timeOff: TimeInput.pure(now),
    ));
  }

  void setDateOn(String value) => emit(state.copyWith(
        autoTime: state.hasTimeOff ? null : false,
        dateOn: DateInput.dirty(value),
      ));

  void setTimeOn(String value) => emit(state.copyWith(
        autoTime: state.hasTimeOff ? null : false,
        timeOn: TimeInput.dirty(value),
      ));

  void setDateOff(String value) => emit(state.copyWith(
        autoTime: false,
        dateOff: DateInput.dirty(value),
      ));

  void setTimeOff(String value) => emit(state.copyWith(
        autoTime: false,
        timeOff: TimeInput.dirty(value),
      ));

  void setCallsign(String value) =>
      emit(state.copyWith(callsign: CallsignInput.dirty(value)));

  int? _newFreqFromBand(Band? band, int? freq) =>
      band?.isInBounds(freq ?? -1) == false ? band!.lowerBound : null;

  void setBand(Band? value) {
    final freq = _newFreqFromBand(value, tryParseFreq(state.frequency.value));
    if (freq == null) return;
    emit(state.copyWith(
      frequency: FrequencyInput.pure(freq),
    ));
  }

  void setFreq(String value) =>
      emit(state.copyWith(frequency: FrequencyInput.dirty(value)));

  void setBandRx(Band? value) {
    final freq = _newFreqFromBand(value, tryParseFreq(state.frequencyRx.value));
    if (freq == null) return;
    emit(state.copyWith(
      frequencyRx: FrequencyInput.pure(freq),
    ));
  }

  void setFreqRx(String value) =>
      emit(state.copyWith(frequencyRx: FrequencyInput.dirty(value)));

  void setMode(Mode? value) => emit(state.copyWithMode(
        mode: value,
        subMode: value?.subModes.contains(state.subMode) == true
            ? state.subMode
            : null,
      ));

  void setSubMode(SubMode? value) => emit(state.copyWithMode(subMode: value));

  void setSplit(bool? value) => emit(state.copyWith(split: value));

  void setRstSent(String value) => emit(state.copyWith(rstSent: value));

  void setRstRecv(String value) => emit(state.copyWith(rstRcvd: value));

  void setPower(String value) => emit(state.copyWith(power: value));

  void setShowContest(bool value) => emit(state.copyWith(
        showContest: value,
        contestSrx: value ? null : '',
        contestStx: value ? null : '',
        contestSrxString: value ? null : '',
        contestStxString: value ? null : '',
      ));

  void setContestSrx(String value) => emit(state.copyWith(contestSrx: value));

  void setContestStx(String value) => emit(state.copyWith(contestStx: value));

  void setContestSrxString(String value) =>
      emit(state.copyWith(contestSrxString: value));

  void setContestStxString(String value) =>
      emit(state.copyWith(contestStxString: value));

  void setShowComment(bool value) => emit(state.copyWith(
        showComment: value,
        comment: value ? null : '',
      ));

  void setComment(String value) => emit(state.copyWith(comment: value));
}
