import 'package:flutter/material.dart';

import 'callsign_lookup.dart';

class CallsignScreen extends StatelessWidget {
  static const constraints = BoxConstraints(maxWidth: 800);

  const CallsignScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Callsign lookup'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              constraints: constraints,
              child: const CallsignLookup(),
            ),
          ),
        ),
      );
}
