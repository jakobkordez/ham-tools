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

  group('fromGridSquare', () {
    test('2', () {
      final res = LatLon.parseGridSquare('JN');

      expect(res.lat, 40);
      expect(res.lon, 0);
    });

    test('4', () {
      final res = LatLon.parseGridSquare('JN76');

      expect(res.lat, 46);
      expect(res.lon, 14);
    });

    test('6', () {
      final res = LatLon.parseGridSquare('JN76db');

      expect(res.lat, closeTo(46.042, 0.001));
      expect(res.lon, closeTo(14.25, 0.001));
    });

    test('8', () {
      final res = LatLon.parseGridSquare('JN76db65');

      expect(res.lat, closeTo(46.0625, 0.0001));
      expect(res.lon, closeTo(14.3, 0.0001));
    });

    test('Bottom edge AA', () {
      final res = LatLon.parseGridSquare('AA');

      expect(res.lat, -90);
      expect(res.lon, -180);
    });

    test('Bottom edge AA00', () {
      final res = LatLon.parseGridSquare('AA00');

      expect(res.lat, -90);
      expect(res.lon, -180);
    });

    test('Top edge RR', () {
      final res = LatLon.parseGridSquare('RR');

      expect(res.lat, 80);
      expect(res.lon, 160);
    });

    test('Top edge RR99', () {
      final res = LatLon.parseGridSquare('RR99');

      expect(res.lat, 89);
      expect(res.lon, 178);
    });

    test('Top edge RR99xx', () {
      final res = LatLon.parseGridSquare('RR99xx');

      expect(res.lat, closeTo(89 + (2.5 * 23) / 60, 0.001));
      expect(res.lon, closeTo(178 + (5 * 23) / 60, 0.001));
    });

    test('Center 2 characters', () {
      final res = LatLon.parseGridSquare('JN', center: true);

      expect(res.lat, 45);
      expect(res.lon, 10);
    });

    test('Center 4 characters', () {
      final res = LatLon.parseGridSquare('JN76', center: true);

      expect(res.lat, 46.5);
      expect(res.lon, 15);
    });

    test('Center 6 characters', () {
      final res = LatLon.parseGridSquare('JN76db', center: true);

      expect(res.lat, closeTo(46.063, 0.001));
      expect(res.lon, closeTo(14.292, 0.001));
    });

    test('Precision', () {
      final res = LatLon.parseGridSquare('RR99xx99xx99xx99');

      expect(res.lat, closeTo(90, 0.000001));
      expect(res.lat, isNot(90));
      expect(res.lon, closeTo(180, 0.000001));
      expect(res.lon, isNot(180));
    });
  });
}
