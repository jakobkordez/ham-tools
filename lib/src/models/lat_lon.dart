import 'dart:math';

import 'package:equatable/equatable.dart';

class LatLon extends Equatable {
  final double lat;
  final double lon;

  const LatLon(this.lat, this.lon);

  static LatLon? parseGridSquare(String value) {
    value = value.toUpperCase();
    if (!RegExp(r'^[A-S]{2}\d{2}([A-X]{2})?$').hasMatch(value)) return null;
    double lon = -180.0;
    double lat = -90.0;
    final aInd = 'A'.codeUnitAt(0);
    final zeroInd = '0'.codeUnitAt(0);
    lon += (value.codeUnitAt(0) - aInd) * 20;
    lat += (value.codeUnitAt(1) - aInd) * 10;
    lon += (value.codeUnitAt(2) - zeroInd) * 2;
    lat += (value.codeUnitAt(3) - zeroInd);
    if (value.length == 6) {
      lon += (value.codeUnitAt(4) - aInd) / 12;
      lat += (value.codeUnitAt(5) - aInd) / 24;
    }
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
