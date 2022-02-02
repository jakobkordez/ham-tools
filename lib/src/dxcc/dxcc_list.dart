import 'package:flutter/material.dart';
import 'package:ham_tools/src/utils/callsign_util.dart';

class DxccList extends StatelessWidget {
  const DxccList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          children: [
            Material(
              color: Theme.of(context).colorScheme.primary,
              elevation: 3,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  padding: const EdgeInsets.all(40),
                  child: const PrefixLookup(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(30),
                constraints: const BoxConstraints(maxWidth: 1000),
                child: const Card(
                  elevation: 3,
                  child: _DxccList(entities: DxccEntity.dxccs),
                ),
              ),
            ),
          ],
        ),
      );
}

class PrefixLookup extends StatefulWidget {
  const PrefixLookup({Key? key}) : super(key: key);

  @override
  State<PrefixLookup> createState() => _PrefixLookupState();
}

class _PrefixLookupState extends State<PrefixLookup> {
  CallsignData? callsignData;

  @override
  Widget build(BuildContext context) {
    final dxcc = callsignData?.prefixDxcc;
    final secDxcc = callsignData?.secPrefixDxcc;

    return Column(
      children: [
        Text(
          'Prefix lookup',
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
        padding: const EdgeInsets.all(20),
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
                child: Image.network(
                  'https://static.qrz.com/static/flags-iso/flat/64/${dxcc.flag}.png',
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

class _DxccList extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final List<DxccEntity> entities;

  const _DxccList({
    Key? key,
    required this.entities,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: padding,
        shrinkWrap: true,
        separatorBuilder: (_, __) =>
            Container(height: 1, color: Colors.grey.shade200),
        itemCount: entities.length,
        itemBuilder: (_, i) {
          final e = entities[i];

          return Column(
            children: [
              ListTile(
                leading: Tooltip(
                  message: e.flag,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: Image.network(
                      'https://static.qrz.com/static/flags-iso/flat/64/${e.flag}.png',
                      width: 32,
                    ),
                  ),
                ),
                title: Text(e.name),
                subtitle: Text(e.prefix),
              ),
              if (e.sub.isNotEmpty)
                _DxccList(
                  entities: e.sub,
                  padding: const EdgeInsets.only(left: 48),
                ),
            ],
          );
        },
      );
}
