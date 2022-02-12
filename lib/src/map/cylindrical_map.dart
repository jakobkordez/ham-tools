import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ham_tools/src/map/cylindrical_painter.dart';

import '../models/lat_lon.dart';

class CylindricalMap extends StatelessWidget {
  final LatLon center;

  const CylindricalMap({
    Key? key,
    required this.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
        ),
        child: FutureBuilder<List<List<Offset>>>(
          future: _buildMapWrapper(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              debugPrint(snapshot.error.toString());
              return const Center(child: Text('Error'));
            }

            final data = snapshot.data!;
            final ocPoint = pointToOffset(const LatLon(90, 0));

            return InteractiveViewer(
              clipBehavior: Clip.none,
              maxScale: 10,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: CustomPaint(
                  isComplex: true,
                  size: Size.infinite,
                  painter: CylindricalPainter(data),
                ),
              ),
            );
          },
        ),
      );

  Future<List<List<Offset>>> _buildMapWrapper() async {
    final raw = await rootBundle.loadString('assets/cil.txt');
    return compute<String, List<List<Offset>>>(_buildMap, raw);
  }
}

Offset pointToOffset(LatLon p) {
  final pt = center.polarCoordTo(p, 1 / pi);
  final angle = (pt.angle - 90) * pi / 180;
  return Offset(
    cos(angle) * pt.distance,
    sin(angle) * pt.distance,
  );
}

Future<List<List<Offset>>> _buildMap(String raw) async {
  Offset rowToOffset(String row) {
    final a = row.substring(1).split(' ').map(double.parse).toList();
    // return pointToOffset(LatLon(a[0], a[1]), center);
  }

  final data = raw.trim().split('\ns').map((e) => e.split('\n').skip(1));
  final res = <List<Offset>>[];

  for (final seg in data) {
    final pts = <Offset>[];
    pts.add(rowToOffset(seg.first));
    for (int i = 1; i < seg.length - 1; i += 1) {
      final pt = rowToOffset(seg.elementAt(i));
      if ((pt.dx - pts.last.dx).abs() > 0.001 ||
          (pt.dy - pts.last.dy).abs() > 0.001) {
        pts.add(pt);
      }
    }
    pts.add(rowToOffset(seg.last));
    res.add(pts);
  }

  return res;
}
