import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageColor {
  final String? imagePath;
  final Color? color;

  ImageColor({this.imagePath, this.color});

  bool isColor() {
    return color != null;
  }

  Color getColor() {
    return color!;
  }

  String getImagePath() {
    return imagePath!;
  }

  Widget getImage(double width, double height) {
      return isColor()
          ? CustomPaint(
              size: Size(width, height),
              painter: ColorPainter(getColor()),
            )
          : Image.asset(getImagePath(), width: width, height: height);
    }

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'color': color?.value,
    };
  }
}

class ColorPainter extends CustomPainter{
  final Color color;

  ColorPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, paint);
  }
  
  @override
  bool shouldRepaint(ColorPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
