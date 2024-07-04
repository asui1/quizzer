import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Paint dotPaint;
  final Color color;

  LinePainter({required this.start, required this.end, required this.color})
      : dotPaint = Paint()
          ..color = color
          ..strokeWidth = 3.0 // Adjust line thickness here
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    const double dotSize = 2; // 점의 크기
    const double space = 5; // 점 사이의 공간
    double distance = (start - end).distance;

    for (double i = 0; i < distance; i += dotSize + space) {
      double x = start.dx + (end.dx - start.dx) * i / distance;
      double y = start.dy + (end.dy - start.dy) * i / distance;
      canvas.drawCircle(Offset(x, y), dotSize / 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
