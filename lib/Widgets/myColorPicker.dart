import 'dart:io';
import 'package:path/path.dart' as path; // Add this line

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quizzer/Class/ImageColor.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Setup/config.dart';

class ColorPickerField extends StatefulWidget {
  final QuizLayout quizLayout;
  final int index;

  ColorPickerField({required this.quizLayout, required this.index});
  @override
  _ColorPickerFieldState createState() => _ColorPickerFieldState();
}

class _ColorPickerFieldState extends State<ColorPickerField> {
  Color pickerColor = Colors.white;
  XFile? imageFile;
  TextEditingController hexController = TextEditingController();
  bool isHexCodeValid = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.index > 2) {
      pickerColor = widget.quizLayout.getColor(widget.index);
    } else {
      pickerColor =
          widget.quizLayout.getImageColorNotNull(widget.index).isColor()
              ? widget.quizLayout.getImageColorNotNull(widget.index).getColor()
              : Colors.white;
    }
    imageFile =
        widget.quizLayout.getImageColorNotNull(widget.index).imagePath == null
            ? null
            : XFile(widget.quizLayout
                .getImageColorNotNull(widget.index)
                .getImagePath());
    hexController.text = colorToHex(pickerColor, enableAlpha: false);
  }

  @override
  Widget build(BuildContext context) {
    String lastTenChars = "";

    if (imageFile != null) {
      String path = imageFile!.path;
      lastTenChars = path.length > 10 ? path.substring(path.length - 10) : path;
    }
    return AlertDialog(
      backgroundColor: widget.quizLayout.getColorScheme().surface,
      content: SingleChildScrollView(
        child: Container(
          width: AppConfig.screenWidth / 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  ColorPicker(
                    labelTypes: [],
                    pickerColor: pickerColor,
                    onColorChanged: (newColor) {
                      setState(() {
                        pickerColor = newColor;
                        hexController.text = newColor.value
                            .toRadixString(16)
                            .substring(2); // Ignore alpha
                      });
                    },
                    portraitOnly: true,
                    pickerAreaHeightPercent: 0.8,
                    enableAlpha: false,
                  ),
                  TextField(
                    controller: hexController,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'Hex code',
                      errorText: isHexCodeValid ? null : 'Invalid hex code',
                    ),
                    onChanged: (value) {
                      try {
                        setState(() {
                          pickerColor = new Color(int.parse('ff' + value,
                              radix: 16)); // Add 'ff' for full opacity
                          isHexCodeValid = true;
                        });
                      } catch (e) {
                        // Handle invalid hex code
                        setState(() {
                          isHexCodeValid = false;
                        });
                      }
                    },
                  ),
                ],
              ),
              widget.index < 3
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Current Path: ${imageFile == null ? 'No image selected' : lastTenChars}',
                            style: TextStyle(fontSize: 16),
                            maxLines: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: SizedBox.shrink(), // 정렬을 위한 자리 표시자
                              ),
                              ElevatedButton(
                                child: Text('Pick Image'),
                                onPressed: () async {
                                  final ImagePicker _picker = ImagePicker();
                                  final XFile? tempImageFile = await _picker
                                      .pickImage(source: ImageSource.gallery);
                                  if (tempImageFile != null) {
                                    // 이미지 파일 처리
                                    setState(() {
                                      imageFile = tempImageFile;
                                    });
                                  }
                                },
                              ),
                              Expanded(
                                child: TextButton(
                                  child: Text('X'),
                                  onPressed: () {
                                    setState(() {
                                      imageFile = null;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('확인'),
          onPressed: () {
            if (widget.index > 2) {
              widget.quizLayout.setColor(widget.index, pickerColor);
              Navigator.of(context).pop(pickerColor);
            } else {
              if (imageFile != null) {
                saveFileToPermanentDirectory(imageFile!).then((value) {
                  widget.quizLayout.setImage(widget.index,
                      ImageColor(imagePath: value.path, color: pickerColor));
                  Navigator.of(context).pop(pickerColor);
                });
              } else {
                widget.quizLayout.setImage(widget.index,
                    ImageColor(imagePath: imageFile?.path, color: pickerColor));
                Navigator.of(context).pop(pickerColor);
              }
            }
          },
        ),
      ],
    );
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
}
