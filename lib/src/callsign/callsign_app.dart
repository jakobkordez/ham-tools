import 'package:flutter/material.dart';
import 'package:ham_tools/src/utils/callsign_util.dart';

import 'dxcc_list.dart';
import 'callsign_lookup.dart';

class CallsignApp extends StatelessWidget {
  const CallsignApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'Callsigns',
        home: CallsignScreen(),
      );
}

class CallsignScreen extends StatelessWidget {
  static const constraints = BoxConstraints(maxWidth: 800);

  const CallsignScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          children: [
            Material(
              elevation: 3,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    constraints: constraints,
                    margin: const EdgeInsets.all(40),
                    child: const CallsignLookup(),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.all(30),
                constraints: constraints,
                child: const Card(
                  elevation: 3,
                  margin: EdgeInsets.zero,
                  child: DxccList(entities: DxccEntity.dxccs),
                ),
              ),
            ),
          ],
        ),
      );
}
