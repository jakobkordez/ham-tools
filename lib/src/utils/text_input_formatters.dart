import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) =>
      TextEditingValue(
        text: newValue.text.toUpperCase(),
        selection: newValue.selection,
      );
}

class DoubleTextFormatter extends FilteringTextInputFormatter {
  DoubleTextFormatter() : super.allow(RegExp(r'[0-9,.]'));

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final value = super.formatEditUpdate(oldValue, newValue);
    return TextEditingValue(
      text: value.text.replaceAll(',', '.'),
      selection: value.selection,
    );
  }
}
