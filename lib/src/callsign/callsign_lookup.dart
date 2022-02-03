import 'package:flutter/material.dart';
import 'package:ham_tools/src/utils/callsign_util.dart';

class CallsignLookup extends StatefulWidget {
  const CallsignLookup({Key? key}) : super(key: key);

  @override
  State<CallsignLookup> createState() => _CallsignLookupState();
}

class _CallsignLookupState extends State<CallsignLookup> {
  CallsignData? callsignData;

  @override
  Widget build(BuildContext context) {
    final dxcc = callsignData?.prefixDxcc;
    final secDxcc = callsignData?.secPrefixDxcc;

    return Column(
      children: [
        Text(
          'Callsign lookup',
          style: Theme.of(context).textTheme.headline4?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          textCapitalization: TextCapitalization.characters,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Search callsign...',
            fillColor: Theme.of(context).colorScheme.onPrimary,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(20),
          ),
          onChanged: (value) => setState(() {
            callsignData = value.isEmpty ? null : CallsignData.parse(value);
          }),
        ),
        if (callsignData != null)
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontFamily: 'RobotoMono'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (callsignData!.secPrefix != null)
                          Text(
                            '${callsignData!.secPrefix}/',
                            style: const TextStyle(color: Colors.purple),
                          ),
                        if (dxcc == null)
                          Text(callsignData!.callsign)
                        else ...[
                          Text(
                            callsignData!.callsign
                                .substring(0, callsignData!.prefixLength!),
                            style: TextStyle(color: Colors.amber.shade800),
                          ),
                          Text(
                            callsignData!.callsign
                                .substring(callsignData!.prefixLength!),
                            style: const TextStyle(color: Colors.green),
                          ),
                          ...callsignData!.secSuffixes.map((e) => Text(
                                '/$e',
                                style: TextStyle(color: Colors.blue.shade800),
                              )),
                        ],
                      ],
                    ),
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
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(
                                    color: Colors.blue.shade800,
                                    fontFamily: 'RobotoMono'),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            secSuffix(callsignData!, e),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          )
      ],
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
        child: Row(
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
      );
}

String secSuffix(CallsignData callsign, String value) {
  value = value.toUpperCase();

  if (value == 'P') return 'Portable';
  if (value == 'QRP') return 'Low power';
  if (value == 'M') return 'Mobile';
  if (value == 'MM') return 'Maritime Mobile';
  if (value == 'AM') return 'Maritime Mobile';
  if (value == 'A') return 'Alternative location';

  if (RegExp(r'^\d$').hasMatch(value)) {
    return 'Own call area, away from primary location';
  }

  return 'Away from primary location';
}
