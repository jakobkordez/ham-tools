import 'package:flutter/material.dart';

import '../utils/callsign_data.dart';

/// Custom Callsign TextEditingController
///
/// Source:
/// https://github.com/micazi/rich_text_controller/blob/master/lib/rich_text_controller.dart
class CallsignEditingController extends TextEditingController {
  final Color secPrefixColor;
  final Color prefixColor;
  final Color suffixColor;
  final Color secSuffixColor;

  CallsignEditingController({
    required this.secPrefixColor,
    required this.prefixColor,
    required this.suffixColor,
    required this.secSuffixColor,
  });

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final text = super.text.toUpperCase();

    if (!RegExp(r'^[A-Z0-9/]*$').hasMatch(text)) {
      return TextSpan(style: style, text: text);
    }

    final data = CallsignData.parse(text);

    return TextSpan(
      style: style,
      children: [
        if (data.secPrefix != null)
          TextSpan(
            text: '${data.secPrefix}/',
            style: TextStyle(color: secPrefixColor),
          ),
        if (data.prefixDxcc == null)
          TextSpan(text: data.callsign)
        else ...[
          TextSpan(
            text: data.callsign.substring(0, data.prefixLength ?? 0),
            style: TextStyle(color: prefixColor),
          ),
          TextSpan(
            text: data.callsign.substring(data.prefixLength ?? 0),
            style: data.isValid ? TextStyle(color: suffixColor) : null,
          ),
          ...data.secSuffixes.map((e) => TextSpan(
                text: '/${e.suffix}',
                style: TextStyle(color: secSuffixColor),
              )),
        ],
      ],
    );
  }
}
