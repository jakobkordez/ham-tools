import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:ham_tools/src/models/lat_lon.dart';

void main() {
  test('polarCoordTo', () {
    const p1 = LatLon(52.205, 0.119);
    const p2 = LatLon(48.857, 2.351);
    final res = p1.polarCoordTo(p2);

    expect(res.distance, closeTo(404300, 100));
    expect(res.angle, closeTo(156.2, 0.1));
  });

  test('polarCoordTo with radius', () {
    const p1 = LatLon(90, 0);
    const p2 = LatLon(-90, 0);
    final res = p1.polarCoordTo(p2, 1 / pi);

    expect(res.distance, 1);
    expect(res.angle, 180);
  });

  test('fromGridSquare 4', () {
    final res = LatLon.parseGridSquare('JN76');

    expect(res, isNotNull);
    expect(res!.lat, 46);
    expect(res.lon, 14);
  });

  test('fromGridSquare 6', () {
    final res = LatLon.parseGridSquare('JN76db');

    expect(res, isNotNull);
    expect(res!.lat, closeTo(46.042, 0.001));
    expect(res.lon, closeTo(14.25, 0.001));
  });
}
