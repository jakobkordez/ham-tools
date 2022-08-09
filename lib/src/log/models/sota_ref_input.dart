import 'package:formz/formz.dart';

enum SotaRefInputError { invalid }

class SotaRefInput extends FormzInput<String, SotaRefInputError> {
  SotaRefInput.pure() : super.pure('');
  const SotaRefInput.dirty(super.value) : super.dirty();

  static final _regex = RegExp(r'^[A-Z0-9]+/[A-Z]+\-\d+$');

  @override
  SotaRefInputError? validator(String value) {
    if (value.isEmpty) return null;
    return _regex.hasMatch(value) ? null : SotaRefInputError.invalid;
  }
}
