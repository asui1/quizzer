import 'dart:io';
import 'dart:math';
import 'package:image/image.dart';

void createRandomColoredImage(List<Color> colors, int width, int height, String fileName) {

  // Create an image
  Image image = Image(width: width, height: height);

  // Define three colors

  // Random number generator
  Random random = Random();

  // Assign a random color to each pixel
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      image.setPixel(x, y, colors[random.nextInt(3)]);
    }
  }

  // Encode the image to PNG
  List<int> png = encodePng(image);
  File(fileName).writeAsBytesSync(png);
  return;
}
