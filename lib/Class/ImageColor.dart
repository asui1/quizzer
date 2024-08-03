import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:quizzer/Functions/Logger.dart';

class ImageColor {
  Uint8List? imageByte; //IMAGE NAME.
  Color? color;
  Color? mainColor = null;

  ImageColor({this.imageByte, this.color});

  void setImage(Uint8List imageByte) {
    this.imageByte = imageByte;
    this.color = null;
    this.mainColor = null;
  }

  Future<ImageColor> fromJson(Map<String, dynamic> json) async {
    if (json.containsKey('imageData')) {
      // Decode the Base64 string to bytes
      imageByte = base64Decode(json['imageData']);
      return ImageColor(imageByte: imageByte, color: null);
    }

    return ImageColor(
      imageByte: imageByte,
      color: json['color'] != null ? Color(json['color']) : null,
    );
  }

  Future<Color> getMainColor() async {
    if (mainColor == null) {
      if (color != null) {
        return color!;
      } else {
        mainColor = await getMainColorOfImage(imageByte!);
        return mainColor!;
      }
    } else {
      return mainColor!;
    }
  }

  bool isColor() {
    return imageByte == null;
  }

  Color getColor() {
    return color!;
  }

  Uint8List getImageByte() {
    return imageByte!;
  }

  Widget getImage(double width, double height) {
    return isColor()
        ? CustomPaint(
            size: Size(width, height),
            painter: ColorPainter(getColor()),
          )
        : Image.memory(imageByte!, width: width, height: height);
  }

  ImageProvider getImageProvider() {
    if (isColor()) {
      ByteData byteData = ByteData(4); // 4 bytes for ARGB
      byteData.setUint8(0, color!.alpha);
      byteData.setUint8(1, color!.red);
      byteData.setUint8(2, color!.green);
      byteData.setUint8(3, color!.blue);
      List<int> imageData = byteData.buffer.asUint8List();
      // Use MemoryImage with the color image data
      return MemoryImage(Uint8List.fromList(imageData));
    } else {
      // Directly use MemoryImage for the image byte array
      return MemoryImage(imageByte!);
    }
  }

  Widget getImageNoSize() {
    return isColor()
        ? CustomPaint(
            painter: ColorPainter(getColor()),
          )
        : Image.memory(imageByte!);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'color': color?.value,
    };

    if (imageByte != null) {
      json['imageData'] = base64Encode(imageByte!);
    }

    return json;
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

Future<Color> getMainColorOfImage(Uint8List imageByte) async {
  // 이미지 파일을 로드합니다.
  img.Image image = img.decodeImage(imageByte)!;

  // 색상 빈도를 저장할 맵을 생성합니다.
  Map<int, int> colorFrequency = {};

  // 이미지의 각 픽셀을 순회하며 색상 빈도를 계산합니다.
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      int pixelColor = image.getPixelSafe(x, y).hashCode;
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
