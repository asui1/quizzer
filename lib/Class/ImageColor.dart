
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

  Image getImage(double width, double height) {
    return isColor() ? Image.asset('images/one.jpg', color: getColor(), width: width, height: height) : Image.asset(getImagePath(), width: width, height: height);
  }


}