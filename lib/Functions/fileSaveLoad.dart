import 'dart:io';
import 'package:path/path.dart' as path; // Add this line
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quizzer/Setup/config.dart';

Future<File?> checkCompressImage(
    XFile? tempImageFile, int width, int height) async {
  if (tempImageFile == null) {
    return null;
  }
  File file = File(tempImageFile.path);
  int fileSize = await file.length();

  if (width == 50 && fileSize < 512 * 1024) {
    return await saveFileToPermanentDirectory(tempImageFile);
  } else if (height < AppConfig.screenHeight / 3 &&
      fileSize < 2 * 1024 * 1024) {
    return await saveFileToPermanentDirectory(tempImageFile);
  } else if (height > AppConfig.screenHeight / 3 &&
      fileSize < 5 * 1024 * 1024) {
    return await saveFileToPermanentDirectory(tempImageFile);
  }
  final File? compressedFile = tempImageFile.path.contains('.jpg')
      ? await FlutterImageCompress.compressAndGetFile(
          tempImageFile.path,
          tempImageFile.path.replaceFirst(
              '.jpg', '_compressed.jpg'), // Example path, adjust accordingly
          quality: 80, // Adjust based on testing
          minWidth: width,
          minHeight: height,
        )
      : await FlutterImageCompress.compressAndGetFile(
          tempImageFile.path,
          tempImageFile.path.replaceFirst(
              '.png', '_compressed.png'), // Adjust the path for PNG
          quality:
              80, // Quality adjustment for PNG might not have as noticeable an effect as with JPEG
          minWidth: width,
          minHeight: height,
          format: CompressFormat.png, // Specify the format as PNG
        );
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
