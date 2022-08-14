import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/lat_lon.dart';
import '../utils/text_input_formatters.dart';
import 'azimuthal_map.dart';

// https://ns6t.net/word/?page_id=10
// https://www.evl.uic.edu/pape/data/WDB/

class AzimuthalMapScreen extends StatefulWidget {
  const AzimuthalMapScreen({Key? key}) : super(key: key);

  @override
  State<AzimuthalMapScreen> createState() => _AzimuthalMapScreenState();
}

class _AzimuthalMapScreenState extends State<AzimuthalMapScreen> {
  final _controller = TextEditingController(text: 'JN76');
  LatLon? center = LatLon.parseGridSquare('JN76');

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Azimuthal map')),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: _controller,
                      onEditingComplete: submit,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        FilteringTextInputFormatter.allow(RegExp(r'[A-X\d]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'QTH Locator',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: submit,
                    child: const Text('Recenter'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: center != null
                      ? AzimuthalMap(center: center!)
                      : Container(
                          color: Colors.red.shade200,
                          child: Center(
                            child: Text(
                              'Invalid QTH Locator',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.red.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      );

  void submit() {
    final loc = LatLon.tryParseGridSquare(_controller.text);
    if (loc != center) {
      setState(() {
        center = loc;
      });
    }
  }
}
