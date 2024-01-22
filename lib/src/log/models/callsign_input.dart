import 'package:formz/formz.dart';

enum CallsignInputError { empty }

class CallsignInput extends FormzInput<String, CallsignInputError> {
  const CallsignInput.pure() : super.pure('');
  const CallsignInput.dirty(super.value) : super.dirty();

  @override
  CallsignInputError? validator(String value) {
    if (value.isEmpty) return CallsignInputError.empty;
    return null;
  }
}
