import 'package:flutter/material.dart';

class CylindricalMapScreen extends StatelessWidget {
  const CylindricalMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('QTH map'),
          centerTitle: true,
        ),
      );
}
