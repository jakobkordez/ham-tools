import 'package:flutter/material.dart';
import 'package:ham_tools/src/map/cylindrical_map.dart';
import 'package:ham_tools/src/models/lat_lon.dart';

class CylindricalMapScreen extends StatelessWidget {
  const CylindricalMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('QTH map'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: CylindricalMap(point: LatLon.parseGridSquare('JN76')),
          ),
        ),
      );
}
