import 'package:formz/formz.dart';

import '../../models/log_entry.dart';

enum DateInputError { empty, invalid }

class DateInput extends FormzInput<String, DateInputError> {
  DateInput.pure(DateTime dt) : super.pure(LogEntry.dateFormat.format(dt));
  const DateInput.dirty(super.value) : super.dirty();

  static final _regex = RegExp(r'^\d{4}[\.\-]?\d\d[\.\-]?\d\d$');

  @override
  DateInputError? validator(String value) {
    if (value.isEmpty) return DateInputError.empty;
    if (!_regex.hasMatch(value)) return DateInputError.invalid;
    return null;
  }
}
