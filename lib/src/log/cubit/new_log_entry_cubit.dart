import 'package:bloc/bloc.dart';
import 'package:ham_tools/src/models/log_entry.dart';

part 'new_log_entry_state.dart';

class NewLogEntryCubit extends Cubit<NewLogEntryState> {
  NewLogEntryCubit() : super(NewLogEntryState());

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

  void setTimeOnNow() => _setTimeOn(DateTime.now());

  void setTimeOffNow() => _setTimeOff(DateTime.now());

  void setDateOn(String value) {
    final p = tryParseDate(value);
    if (p == null) return;
    _setTimeOn(DateTime.utc(
      p.year,
      p.month,
      p.day,
      state.timeOn.hour,
      state.timeOn.minute,
    ));
  }

  void setTimeOn(String value) {
    final p = tryParseTime(value);
    if (p == null) return;
    _setTimeOn(DateTime.utc(
      state.timeOn.year,
      state.timeOn.month,
      state.timeOn.day,
      p ~/ 100,
      p % 100,
    ));
  }

  void setDateOff(String value) {
    final p = tryParseDate(value);
    if (p == null) return;
    _setTimeOn(DateTime.utc(
      p.year,
      p.month,
      p.day,
      state.timeOff.hour,
      state.timeOff.minute,
    ));
  }

  void setTimeOff(String value) {
    final p = tryParseTime(value);
    if (p == null) return;
    _setTimeOff(DateTime.utc(
      state.timeOff.year,
      state.timeOff.month,
      state.timeOff.day,
      p ~/ 100,
      p % 100,
    ));
  }

  void _setTimeOn(DateTime value) => emit(state.copyWith(
        timeOn: value,
        timeOff: value.isAfter(state.timeOff) ? value : null,
      ));

  void _setTimeOff(DateTime value) => emit(state.copyWith(
        timeOn: value.isBefore(state.timeOff) ? value : null,
        timeOff: value,
      ));

  void setCallsign(String value) => emit(state.copyWith(
        callsign: value,
      ));

  int? _newFreqFromBand(Band? band, int freq) =>
      band?.isInBounds(freq) == false ? band!.lowerBound : null;

  void setBand(Band? value) => emit(state.copyWith(
        frequency: _newFreqFromBand(value, state.frequency),
      ));

  void setFreq(String value) => emit(state.copyWith(
        frequency: tryParseFreq(value),
      ));

  void setBandRx(Band? value) => emit(state.copyWith(
        frequencyRx: _newFreqFromBand(value, state.frequencyRx),
      ));

  void setFreqRx(String value) => emit(state.copyWith(
        frequencyRx: tryParseFreq(value),
      ));

  void setMode(Mode? value) => emit(state.copyWith(
        mode: value,
      ));

  void setSplit(bool? value) => emit(state.copyWith(
        split: value,
      ));

  void setRstSent(String value) => emit(state.copyWith(
        rstSent: value,
      ));

  void setRstRecv(String value) => emit(state.copyWith(
        rstReceived: value,
      ));

  void setPower(String value) => emit(state.copyWith(
        power: int.tryParse(value) ?? -1,
      ));
}
