import 'package:flutter/material.dart';
import 'package:ham_tools/src/stats/qso_stats.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final controller = TextEditingController();
  QsoStats? qsoStats;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('QSO stats')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    controller: controller,
                    maxLines: 5,
                    minLines: 5,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        qsoStats = QsoStats.parse(controller.text);
                      });
                    },
                    child: const Text('Parse'),
                  ),
                  if (qsoStats != null) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Column(
                          children: qsoStats!.mode.entries
                              .map((e) => Text('${e.key}: ${e.value}'))
                              .toList(),
                        ),
                        Column(
                          children: qsoStats!.band.entries
                              .map((e) => Text('${e.key}: ${e.value}'))
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
}
