import 'dart:math';

import 'package:equatable/equatable.dart';

class LatLon extends Equatable {
  static final _gridRe =
      RegExp(r'^[A-R]{2}(\d\d[A-X]{2})*(\d\d)?$', caseSensitive: false);

  final double lat;
  final double lon;

  const LatLon(this.lat, this.lon);

  static LatLon parseGridSquare(String value, {bool center = false}) {
    final latLon = tryParseGridSquare(value, center: center);
    if (latLon == null) throw FormatException('Invalid grid square: $value');
    return latLon;
  }

  static LatLon? tryParseGridSquare(String locator, {bool center = false}) {
    locator = locator.toUpperCase();
    if (!_gridRe.hasMatch(locator)) return null;

    const aInd = 65;
    const zeroInd = 48;

    double lon = 0;
    double lat = 0;

    int div = 1;
    for (int i = 0; i < locator.length; i += 2) {
      final sub = i % 4 == 0 ? aInd : zeroInd;
      lon += (locator.codeUnitAt(i) - sub) * 2;
      lat += (locator.codeUnitAt(i + 1) - sub);

      final mult = i % 4 == 0 ? 10 : 24;
      div *= mult;
      lon *= mult;
      lat *= mult;
    }

    if (center) {
      lon += locator.length % 4 == 0 ? 24 : 10;
      lat += locator.length % 4 == 0 ? 12 : 5;
    }

    lon = (lon / div) * 10 - 180;
    lat = (lat / div) * 10 - 90;

    return LatLon(lat, lon);
  }

  PolarCoord polarCoordTo(LatLon to, [double radius = 6371e3]) {
    double radians(double value) => value * pi / 180;
    double degrees(double value) => value * 180 / pi;

    final lat1 = radians(lat);
    final lon1 = radians(lon);
    final lat2 = radians(to.lat);
    final lon2 = radians(to.lon);
    final dlat = lat2 - lat1;
    final dlon = lon2 - lon1;

    final a = sin(dlat / 2) * sin(dlat / 2) +
        cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final d = radius * c;

    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dlon);
    final y = sin(dlon) * cos(lat2);
    final angle = degrees(atan2(y, x));

    return PolarCoord(d, angle);
  }

  @override
  List<Object?> get props => [lat, lon];
}

class PolarCoord extends Equatable {
  final double distance;
  final double angle;

  const PolarCoord(this.distance, this.angle);

  @override
  List<Object?> get props => [distance, angle];
}
