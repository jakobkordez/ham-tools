import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ham_tools/src/models/log_entry.dart';

part 'new_log_entry_state.dart';

class NewLogEntryCubit extends Cubit<NewLogEntryState> {
  NewLogEntryCubit([LogEntry? last])
      : super(last == null
            ? NewLogEntryState()
            : NewLogEntryState(
                frequency: last.frequency,
                mode: last.mode,
                subMode: last.subMode,
                frequencyRx: last.frequencyRx,
                power: last.power,
              ));

  static int? tryParseTime(String value) {
    final p = int.tryParse(value);
    if (p == null || p.isNegative || p >= 2400 || p % 100 >= 60) return null;
    return p;
  }

  static DateTime? tryParseDate(String value) {
    value = value.replaceAll(RegExp(r'\D+'), '');
    if (value.length != 8) return null;
    return DateTime.parse('${value}T00Z');
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

  void clear() => emit(NewLogEntryState(
        frequency: tryParseFreq(state.frequency),
        frequencyRx: tryParseFreq(state.frequencyRx),
        mode: state.mode,
        subMode: state.subMode,
        power: int.tryParse(state.power),
      ));

  void setTimeOnNow() {
    final now = DateTime.now().toUtc();
    emit(state.copyWith(
      dateOn: LogEntry.dateFormat.format(now),
      timeOn: LogEntry.timeFormat.format(now),
    ));
  }

  void setTimeOffNow() {
    final now = DateTime.now().toUtc();
    emit(state.copyWith(
      dateOff: LogEntry.dateFormat.format(now),
      timeOff: LogEntry.timeFormat.format(now),
    ));
  }

  void setDateOn(String value) => emit(state.copyWith(dateOn: value));

  void setTimeOn(String value) => emit(state.copyWith(timeOn: value));

  void setDateOff(String value) => emit(state.copyWith(dateOff: value));

  void setTimeOff(String value) => emit(state.copyWith(timeOff: value));

  void setCallsign(String value) => emit(state.copyWith(callsign: value));

  String? _newFreqFromBand(Band? band, int? freq) =>
      band?.isInBounds(freq ?? -1) == false
          ? LogEntry.freqFormat.format(band!.lowerBound / 1000000)
          : null;

  void setBand(Band? value) => emit(state.copyWith(
        frequency: _newFreqFromBand(value, tryParseFreq(state.frequency)),
      ));

  void setFreq(String value) => emit(state.copyWith(frequency: value));

  void setBandRx(Band? value) => emit(state.copyWith(
        frequencyRx: _newFreqFromBand(value, tryParseFreq(state.frequencyRx)),
      ));

  void setFreqRx(String value) => emit(state.copyWith(frequencyRx: value));

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
}
