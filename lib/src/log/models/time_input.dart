import 'package:formz/formz.dart';

import '../../models/log_entry.dart';

enum TimeInputError { empty, invalid }

class TimeInput extends FormzInput<String, TimeInputError> {
  TimeInput.pure(DateTime dt) : super.pure(LogEntry.timeFormat.format(dt));
  const TimeInput.dirty(super.value) : super.dirty();

  static final _regex = RegExp(r'^\d{4}|\d?\d[\.:]\d\d$');

  @override
  TimeInputError? validator(String value) {
    if (value.isEmpty) return TimeInputError.empty;
    if (!_regex.hasMatch(value)) return TimeInputError.invalid;
    final t = int.parse(value.replaceAll(r'\D+', ''));
    if (t % 100 > 59 || t > 2359) return TimeInputError.invalid;
    return null;
  }
}
