import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/lat_lon.dart';
import 'cylindrical_painter.dart';

class CylindricalMap extends StatelessWidget {
  final LatLon? point;

  const CylindricalMap({
    super.key,
    this.point,
  });

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
            final pointOffset = point != null ? pointToOffset(point!) : null;
            final top =
                (pi - log(tan(pi / 4 + toRad(85.051129) / 2))) / (2 * pi);
            final bot =
                (pi - log(tan(pi / 4 + toRad(-85.051129) / 2))) / (2 * pi);

            return InteractiveViewer(
              clipBehavior: Clip.none,
              maxScale: 10,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: CustomPaint(
                  isComplex: true,
                  size: Size.infinite,
                  painter: CylindricalPainter(
                    data,
                    top,
                    bot,
                    point: pointOffset,
                  ),
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

// double secDeg(double degrees) =>
//     (degrees.isNegative ? -180 : 180) / (pi * cos(degrees * pi / 180));

// double test(double deg) => log(tan(pi / 4 + deg * pi / 360)) / pi * 180;

double toRad(double deg) => deg * pi / 180;

Offset pointToOffset(LatLon p) => Offset(
      (toRad(p.lon) + pi) / (2 * pi) - 0.5,
      (pi - log(tan(pi / 4 + toRad(p.lat) / 2))) / (2 * pi) - 0.5,
    );

Future<List<List<Offset>>> _buildMap(String raw) async {
  Offset rowToOffset(String row) {
    final a = row.substring(1).split(' ').map(double.parse).toList();
    if (a[0] < -180) a[0] += 360;
    if (a[0] > 180) a[0] -= 360;
    if (a[1] < -180) a[1] += 360;
    if (a[1] > 180) a[1] -= 360;
    return pointToOffset(LatLon(a[0], a[1]));
  }

  bool isFurther(Offset first, Offset second, double delta) =>
      (first.dx - second.dx).abs() > delta ||
      (first.dy - second.dy).abs() > delta;

  final data = raw.trim().split('\ns').map((e) => e.split('\n').skip(1));
  final res = <List<Offset>>[];

  for (final seg in data) {
    final pts = <Offset>[];
    pts.add(rowToOffset(seg.first));
    for (int i = 1; i < seg.length - 1; i += 1) {
      final pt = rowToOffset(seg.elementAt(i));
      if (isFurther(pt, pts.last, 0.7)) {
        final edge = pts.last.dx > 0 ? 0.5 : -0.5;
        pts.addAll([
          Offset(edge, pts.last.dy),
          Offset(edge, 0.5),
          Offset(-edge, 0.5),
          Offset(-edge, pts.last.dy),
          pt,
        ]);
      } else if (isFurther(pt, pts.last, 0.001)) {
        pts.add(pt);
      }
    }
    pts.add(rowToOffset(seg.last));
    res.add(pts);
  }

  return res;
}
