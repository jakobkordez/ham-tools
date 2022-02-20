import 'dart:math';

import 'package:flutter/material.dart';

class CylindricalPainter extends CustomPainter {
  final List<List<Offset>> data;
  final double top;
  final double bottom;
  final Offset? point;

  CylindricalPainter(this.data, this.top, this.bottom, {this.point});

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
    final s = min(size.height, size.width);

    canvas.translate(center.dx, center.dy);
    canvas.scale(s, s);
    canvas.drawRect(
      const Rect.fromLTWH(-0.5, -0.5, 1, 1),
      Paint()..color = Colors.lightBlue.shade100,
    );

    var path = Path()..fillType = PathFillType.evenOdd;
    for (final grp in data) {
      path.addPolygon(grp, true);
    }

    canvas.drawPath(path, brush);
    canvas.drawPath(path, Paint()..style = PaintingStyle.stroke);

    // Horizontal
    // for (int i = 0; i < )

    line.color = Colors.black;
    line.strokeWidth = 1.5;
    canvas.drawRect(Rect.fromCenter(center: center, width: 4, height: 2), line);

    if (point != null) {
      canvas.drawCircle(
        point!,
        0.005,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
