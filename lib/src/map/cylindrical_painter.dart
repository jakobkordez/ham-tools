import 'package:flutter/material.dart';

class CylindricalPainter extends CustomPainter {
  final List<List<Offset>> data;

  CylindricalPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
