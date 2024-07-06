import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

class ImageColor {
  String? imagePath;
  Color? color;
  Color? mainColor = null;

  ImageColor({this.imagePath, this.color});

  void setImage(String imagePath) {
    print("Image Set: $imagePath");
    this.imagePath = imagePath;
    this.color = null;
    this.mainColor = null;
  }

  ImageColor fromJson(Map<String, dynamic> json) {
    return ImageColor(
      imagePath: json['imagePath'],
      color: json['color'] != null ? Color(json['color']) : null,
    );
  }

  Future<Color> getMainColor() async {
    if (mainColor == null) {
      if (color != null) {
        return color!;
      } else {
        mainColor = await getMainColorOfImage(imagePath!);
        return mainColor!;
      }
    } else {
      return mainColor!;
    }
  }

  bool isColor() {
    return imagePath == null;
  }

  Color getColor() {
    return color!;
  }

  String getImagePath() {
    return imagePath!;
  }

  Widget getImage(double width, double height) {
    print("IsImage: ${!isColor()}");
    return isColor()
        ? CustomPaint(
            size: Size(width, height),
            painter: ColorPainter(getColor()),
          )
        : Image.file(File(getImagePath()), width: width, height: height);
  }

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'color': color?.value,
    };
  }
}

class ColorPainter extends CustomPainter {
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

Future<Color> getMainColorOfImage(String imagePath) async {
  // 이미지 파일을 로드합니다.
  img.Image image = img.decodeImage(File(imagePath).readAsBytesSync())!;

  // 색상 빈도를 저장할 맵을 생성합니다.
  Map<int, int> colorFrequency = {};

  // 이미지의 각 픽셀을 순회하며 색상 빈도를 계산합니다.
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      int pixelColor = image.getPixel(x, y) as int;
      colorFrequency[pixelColor] = (colorFrequency[pixelColor] ?? 0) + 1;
    }
  }

  // 가장 빈번한 색상을 찾습니다.
  int mostFrequentColor =
      colorFrequency.entries.reduce((a, b) => a.value > b.value ? a : b).key;

  // Color 객체로 변환합니다.
  int red = (mostFrequentColor >> 16) & 0xFF;
  int green = (mostFrequentColor >> 8) & 0xFF;
  int blue = mostFrequentColor & 0xFF;

  return Color.fromRGBO(red, green, blue, 1.0);
}
