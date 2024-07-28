import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path; // Add this line
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quizzer/Class/ImageColor.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Class/scoreCard.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Setup/Colors.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:image/image.dart' as img;
// import 'dart:html' as html;

Future<File?> checkCompressImage(
    XFile? tempImageFile, int width, int height) async {
  if (tempImageFile == null) {
    return null;
  }
  File file = File(tempImageFile.path);
  int fileSize = await file.length();

  if (width == 50 && fileSize < 64 * 1024) {
    return await saveFileToPermanentDirectory(tempImageFile);
  } else if (height < AppConfig.screenHeight / 3 && fileSize < 258 * 1024) {
    return await saveFileToPermanentDirectory(tempImageFile);
  } else if (height > AppConfig.screenHeight / 3 && fileSize < 1024 * 1024) {
    return await saveFileToPermanentDirectory(tempImageFile);
  }

  int targetSize = 11;
  if (width == 50)
    targetSize = 64 * 1024;
  else if (height < AppConfig.screenHeight / 3)
    targetSize = 258 * 1024;
  else if (height > AppConfig.screenHeight / 3) targetSize = 1024 * 1024;
  final File? compressedFile =
      await compressImageToTargetSize(tempImageFile, targetSize);
  return compressedFile;
}

Future<File?> compressImageToTargetSize(
    XFile imageFile, int targetSizeInBytes) async {
  int quality = 90; // 시작 품질
  File? compressedFile;
  var currentSize = await File(imageFile.path).length();

  while (currentSize > targetSizeInBytes && quality > 0) {
    // 임시 파일 경로 생성
    String targetPath = imageFile.path.replaceFirst('.jpg', '_compressed.jpg');
    // 이미지 압축
    compressedFile = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      targetPath,
      quality: quality,
      format: CompressFormat.jpeg,
    );

    if (compressedFile == null) {
      return null; // 압축 실패
    }

    currentSize = await compressedFile.length();
    quality -= 10; // 품질 감소
  }

  return compressedFile;
}

Future<File> saveFileToPermanentDirectory(XFile xFile) async {
  // 영구 저장소의 경로를 얻습니다.
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

  // 새 파일 경로를 생성합니다.
  final String fileName = path.basename(xFile.path);
  final File permanentFile = File('$appDocPath/$fileName');

  // XFile을 영구 디렉토리로 복사합니다.
  await xFile.saveTo(permanentFile.path);

  return permanentFile;
}

Future<Uint8List> compressImage(
    Uint8List imageData, int limitSize, int width, int height,
    {int quality = 100}) async {
  // Uint8List 형태의 이미지 데이터를 img.Image 객체로 디코딩합니다.

  if (imageData.lengthInBytes < limitSize) {
    return imageData;
  }

  img.Image? image = img.decodeImage(imageData);
  if (image == null) {
    throw Exception("이미지 디코딩 실패");
  }
  if (width == 150) {
    width = 450;
    height = 450;
  }
  if (width == 400) {
    width = 800;
    height = 800;
  }
  if (image.width > width || image.height > height) {
    image = img.copyResize(image, width: width * 3);
  }

  // 원하는 비율로 중앙에서 자르기
  int originalWidth = image.width;
  int originalHeight = image.height;
  int newWidth = width;
  int newHeight = height;

  if (newHeight > originalHeight) {
    newWidth = originalWidth * originalHeight ~/ newHeight;
    newHeight = originalHeight;
  }
  if (newWidth > originalWidth) {
    newHeight = originalHeight * originalWidth ~/ newWidth;
    newWidth = originalWidth;
  }

  int xOffset = (originalWidth - newWidth) ~/ 2;
  int yOffset = (originalHeight - newHeight) ~/ 2;

  img.Image croppedImage = img.copyCrop(image,
      x: xOffset, y: yOffset, width: newWidth, height: newHeight);

  Uint8List compressedImageData;

  int currentSize;

  do {
    Logger.log("Quality: $quality");
    // 이미지를 지정된 품질로 압축합니다.
    compressedImageData =
        Uint8List.fromList(img.encodeJpg(croppedImage, quality: quality));
    currentSize = compressedImageData.length;

    // 파일 크기가 limitSize보다 크고 품질이 0보다 크면 품질을 10 감소시킵니다.
    if (currentSize > limitSize && quality > 0) {
      quality -= 10;
    }
  } while (currentSize > limitSize && quality > 0);

  return compressedImageData;
}

String makeScoreCardJson(QuizLayout quizLayout) {
  ScoreCard scoreCard = quizLayout.getScoreCard();
  Map<String, dynamic> scoreCardJson = scoreCard.toJson();
  scoreCardJson['borderColor'] = quizLayout.getColorScheme().outline.value;
  if (scoreCard.imageState == 0) {
    ImageColor? backgroundImage = quizLayout.getImage(0);
    if (backgroundImage == null) {
      scoreCardJson['isColor'] = true;
      scoreCardJson['color'] = quizLayout.getColorScheme().surface.value;
    } else {
      bool isColor = backgroundImage.isColor();
      if (isColor) {
        scoreCardJson['isColor'] = true;
        scoreCardJson['color'] = backgroundImage.getColor().value;
      } else {
        scoreCardJson['isColor'] = false;
        scoreCardJson['imageData'] = backgroundImage.imageByte;
      }
    }
  } else {
    scoreCardJson['isColor'] = true;
    scoreCardJson['color'] =
        scoreCard.getColorByState(quizLayout, scoreCard.imageState).value;
  }

  return jsonEncode(scoreCardJson);
}

ScoreCard makeScoreCardFromJson(String json) {
  Map<String, dynamic> scoreCardJson = jsonDecode(json);
  BoxDecoration backgroundImage = BoxDecoration();
  if (scoreCardJson['isColor']) {
    backgroundImage = BoxDecoration(
      color: stringToColor(scoreCardJson['color']),
      borderRadius: BorderRadius.circular(30), // 모서리 둥글기
      boxShadow: [
        BoxShadow(
          color: stringToColor(scoreCardJson['borderColor'])
              .withOpacity(0.5), // 그림자 색상
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 3), // 그림자 위치 조정
        ),
      ],
    );
  } else {
    backgroundImage = BoxDecoration(
      image: DecorationImage(
        image: decodeImageFromString(scoreCardJson['imageData']),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(30), // 모서리 둥글기
      boxShadow: [
        BoxShadow(
          color: stringToColor(scoreCardJson['borderColor'])
              .withOpacity(0.5), // 그림자 색상
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 3), // 그림자 위치 조정
        ),
      ],
    );
  }
  ScoreCard scoreCard = ScoreCard(
    size: scoreCardJson['size'],
    xRatio: scoreCardJson['dx'],
    yRatio: scoreCardJson['dy'],
    backgroundImage: backgroundImage,
    imageState: int.parse(scoreCardJson['imageState']),
  );

  return scoreCard;
}

// void saveFileToPermanentDirectoryWeb(String fileName, Uint8List fileContent) {
//   // Blob 객체 생성
//   final blob = html.Blob([fileContent]);
//   // Blob 객체로부터 URL 생성
//   final url = html.Url.createObjectUrlFromBlob(blob);
//   // a 태그 생성 및 설정
//   final anchor = html.AnchorElement(href: url)
//     ..setAttribute("download", fileName)
//     ..click();
//   // 생성된 URL 해제
//   html.Url.revokeObjectUrl(url);
// }

ImageProvider decodeImageFromString(String imageData) {
  Uint8List bytes = base64Decode(imageData);
  return MemoryImage(bytes);
}
