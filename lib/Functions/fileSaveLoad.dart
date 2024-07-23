import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path; // Add this line
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:image/image.dart' as img;

Future<File?> checkCompressImage(
    XFile? tempImageFile, int width, int height) async {
  if (tempImageFile == null) {
    return null;
  }
  File file = File(tempImageFile.path);
  int fileSize = await file.length();

  if (width == 50 && fileSize < 64 * 1024) {
    return await saveFileToPermanentDirectory(tempImageFile);
  } else if (height < AppConfig.screenHeight / 3 &&
      fileSize < 258 * 1024) {
    return await saveFileToPermanentDirectory(tempImageFile);
  } else if (height > AppConfig.screenHeight / 3 &&
      fileSize < 1024 * 1024) {
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
    String targetPath =
        imageFile.path.replaceFirst('.jpg', '_compressed.jpg');
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

Future<Uint8List> compressImage(Uint8List imageData, {int quality = 70}) async {
  // Uint8List 형태의 이미지 데이터를 img.Image 객체로 디코딩합니다.
  img.Image? image = img.decodeImage(imageData);

  // 이미지를 압축합니다. quality는 0에서 100 사이의 값으로, 낮을수록 더 많이 압축됩니다.
  img.Image compressedImage = img.copyResize(image!, width: 600); // 필요한 경우 크기 조정
  Uint8List compressedImageData = Uint8List.fromList(img.encodeJpg(compressedImage, quality: quality));

  return compressedImageData;
}