import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double dotSpacing;
  final double dotRadius;

  DottedLinePainter({
    this.color = Colors.white,
    this.dotSpacing = 8,
    this.dotRadius = 2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round;

    double startX = 0;
    final centerY = size.height / 2;

    while (startX < size.width) {
      canvas.drawCircle(Offset(startX, centerY), dotRadius, paint);
      startX += dotSpacing;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
