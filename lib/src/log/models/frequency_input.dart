import 'package:formz/formz.dart';

import '../../models/log_entry.dart';

enum FrequencyInputError { empty, invalid }

class FrequencyInput extends FormzInput<String, FrequencyInputError> {
  FrequencyInput.pure(int freq)
      : super.pure(LogEntry.freqFormat.format(freq / 1000000));
  const FrequencyInput.dirty(super.value) : super.dirty();

  static final _regex = RegExp(r'^\d*(\.\d*)?$');

  @override
  FrequencyInputError? validator(String value) {
    if (value.isEmpty) return FrequencyInputError.empty;
    if (!_regex.hasMatch(value)) return FrequencyInputError.invalid;
    return null;
  }
}
