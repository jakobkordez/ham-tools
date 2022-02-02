import 'package:flutter/material.dart';
import 'package:ham_tools/src/dxcc/dxcc_list.dart';

class CallsignApp extends StatelessWidget {
  const CallsignApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'Callsigns',
        home: DxccList(),
      );
}
