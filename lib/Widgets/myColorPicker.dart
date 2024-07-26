import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path; // Add this line

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quizzer/Class/ImageColor.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/fileSaveLoad.dart';
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
    super.initState();
    if (widget.index > 2) {
      pickerColor = widget.quizLayout.getColor(widget.index);
    } else {
      pickerColor =
          widget.quizLayout.getImageColorNotNull(widget.index).isColor()
              ? widget.quizLayout.getImageColorNotNull(widget.index).getColor()
              : Colors.white;
    }
    hexController.text = colorToHex(pickerColor, enableAlpha: false);
  }

  @override
  Widget build(BuildContext context) {
    String lastTenChars = "";

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
                    key: const ValueKey("quizLayoutHexField"),
                    controller: hexController,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'Hex code',
                      errorText: isHexCodeValid
                          ? null
                          : Intl.message("Invalid_hex_code"),
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
                            '${imageFile == null ? Intl.message("No_image_selected") : Intl.message("Image_selected")}',
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
                                child: Text(Intl.message("Pick_Image")),
                                onPressed: () async {
                                  final ImagePicker _picker = ImagePicker();
                                  final XFile? tempImageFile = await _picker
                                      .pickImage(source: ImageSource.gallery);
                                  if (tempImageFile != null) {
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
          key: const ValueKey('ColorPickerConfirm'),
          child: Text(Intl.message("OK")),
          onPressed: () async {
            if (widget.index > 2) {
              widget.quizLayout.setColor(widget.index, pickerColor);
              Navigator.of(context).pop(pickerColor);
            } else {
              if (imageFile != null) {
                double width = AppConfig.screenWidth;
                double height;
                if (widget.index == 0) {
                  height = AppConfig.screenHeight -
                      widget.quizLayout.getAppBarHeight() -
                      widget.quizLayout.getBottomBarHeight();
                } else if (widget.index == 1) {
                  height = widget.quizLayout.getAppBarHeight();
                } else {
                  height = widget.quizLayout.getBottomBarHeight();
                }
                Uint8List file = await imageFile!.readAsBytes();
                int limitSize;
                if (widget.index == 0) {
                  limitSize = 2 * 1024 * 1024;
                  height = widget.quizLayout.getBodyHeight();
                } else {
                  if(widget.index == 1){
                    height = widget.quizLayout.getAppBarHeight();
                  }
                  else{
                    height = widget.quizLayout.getBottomBarHeight();
                  }
                  limitSize = 500 * 1024;
                }
                Uint8List compressedFile = await compressImage(
                    file, limitSize, width.round(), height.round());
                widget.quizLayout.setImage(
                    widget.index, ImageColor(imageByte: compressedFile));
                Navigator.of(context).pop(pickerColor);
              } else {
                widget.quizLayout.setImage(widget.index,
                    ImageColor(imageByte: null, color: pickerColor));
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
