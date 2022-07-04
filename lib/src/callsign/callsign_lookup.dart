import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ham_tools/src/callsign/callsign_editing_controller.dart';
import 'package:ham_tools/src/utils/callsign_util.dart';
import 'package:ham_tools/src/utils/text_input_formatters.dart';

class CallsignLookup extends StatefulWidget {
  const CallsignLookup({Key? key}) : super(key: key);

  @override
  State<CallsignLookup> createState() => _CallsignLookupState();
}

class _CallsignLookupState extends State<CallsignLookup> {
  final _controller = CallsignEditingController(
    secPrefixColor: Colors.purple,
    prefixColor: Colors.amber.shade800,
    suffixColor: Colors.green,
    secSuffixColor: Colors.blue.shade800,
  );

  CallsignData? callsignData;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dxcc = callsignData?.prefixDxcc;
    final secDxcc = callsignData?.secPrefixDxcc;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextFormField(
              controller: _controller,
              inputFormatters: [
                UpperCaseTextFormatter(),
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9/]')),
              ],
              onChanged: (value) => setState(() {
                callsignData = value.isEmpty ? null : CallsignData.parse(value);
              }),
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Enter callsign...',
                hintStyle: textTheme.headline4,
                border: InputBorder.none,
              ),
              style: textTheme.headline4!.copyWith(fontFamily: 'RobotoMono'),
            ),
          ),
          if (secDxcc != null)
            _DxccView(
              dxcc: secDxcc,
              color: Colors.purple,
            ),
          if (dxcc != null)
            _DxccView(
              dxcc: dxcc,
              color: Colors.amber.shade800,
            ),
          if (callsignData != null)
            ...callsignData!.secSuffixes.map((e) => Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 25,
                  ),
                  color: Colors.blue.shade800.withAlpha(50),
                  child: Row(
                    children: [
                      Text(
                        '/$e',
                        style: textTheme.headline5?.copyWith(
                            color: Colors.blue.shade800,
                            fontFamily: 'RobotoMono'),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        secSuffix(callsignData!, e),
                        style: textTheme.headlineSmall,
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}

class _DxccView extends StatelessWidget {
  final DxccEntity dxcc;
  final Color? color;

  const _DxccView({Key? key, required this.dxcc, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        color: color?.withAlpha(70),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 15,
          runSpacing: 15,
          children: [
            Row(
              children: [
                Tooltip(
                  message: dxcc.flag,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color?.withAlpha(100),
                    ),
                    child: Image.asset(
                      'assets/flags/64/${dxcc.flag}.png',
                      width: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  dxcc.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
            Text(
              'DXCC: ${dxcc.dxcc}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'CQ: ${dxcc.cqZone}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'ITU: ${dxcc.ituZone}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Timezone: GMT${dxcc.timezoneOffset.isNegative ? '-' : '+'}${dxcc.timezoneOffset}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
}

String secSuffix(CallsignData callsign, String value) {
  value = value.toUpperCase();

  if (value == 'P') return 'Portable';
  if (value == 'QRP') return 'Low power';
  if (value == 'M') return 'Mobile';
  if (value == 'MM') return 'Maritime Mobile';
  if (value == 'AM') return 'Aeronautical Mobile';
  if (value == 'A') return 'Alternative location';

  if (RegExp(r'^\d$').hasMatch(value)) {
    return 'Own call area, away from primary location';
  }

  return 'Away from primary location';
}
