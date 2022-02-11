import 'dart:math';

import 'package:flutter/material.dart';

class AzimuthalPainter extends CustomPainter {
  final List<List<Offset>> data;
  final Offset oceanPoint;

  AzimuthalPainter(this.data, this.oceanPoint);

  @override
  void paint(Canvas canvas, Size size) {
    final brush = Paint()
      ..color = Colors.green.shade700
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.6;
    final line = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4;

    final center = Offset(size.width / 2, size.height / 2);
    final r = min(size.width, size.height) / 2;

    canvas.drawCircle(
      center,
      r,
      Paint()..color = Colors.lightBlue.shade100,
    );

    var path = Path()..fillType = PathFillType.evenOdd;
    for (final grp in data) {
      path.addPolygon(grp.map((e) => e.scale(r, r)).toList(), true);
    }
    if (path.contains(oceanPoint.scale(r, r))) {
      path.addOval(Rect.fromCircle(center: Offset.zero, radius: r));
    }

    path = path.shift(center);
    canvas.drawPath(path, brush);
    canvas.drawPath(path, Paint()..style = PaintingStyle.stroke);

    void drawLines(int start, int inc, double innerRad) {
      for (; start < 360; start += inc) {
        final rad = start * pi / 180;
        canvas.drawLine(
          center + Offset(cos(rad) * innerRad, sin(rad) * innerRad),
          center + Offset(cos(rad) * r, sin(rad) * r),
          line,
        );
      }
    }

    // 30 deg lines
    drawLines(0, 30, 0);
    // 10 deg lines
    drawLines(0, 10, r / 4);
    // 5 deg lines
    drawLines(5, 5, r / 2);

    canvas.drawCircle(center, r / 4, line);
    canvas.drawCircle(center, 2 * r / 4, line);
    canvas.drawCircle(center, 3 * r / 4, line);
    line.color = Colors.black;
    line.strokeWidth = 1.5;
    canvas.drawCircle(center, r, line);

    canvas.drawCircle(
      center,
      1,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
