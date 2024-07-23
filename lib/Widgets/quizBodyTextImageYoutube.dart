import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/fileSaveLoad.dart';
import 'package:quizzer/Setup/TextStyle.dart';

class ContentWidget extends StatefulWidget {
  final BuildContext context;
  final Function(int value) updateStateCallback;
  final Quiz1 quiz1;
  final QuizLayout quizLayout;
  final Function(String value) updateBodyTextCallback;

  ContentWidget({
    Key? key,
    required this.context,
    required this.updateStateCallback,
    required this.quiz1,
    required this.quizLayout,
    required this.updateBodyTextCallback,
  }) : super(key: key);

  @override
  _ContentWidgetState createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  late TextEditingController _bodyTextController;

  @override
  void initState() {
    super.initState();
    _bodyTextController =
        TextEditingController(text: widget.quiz1.getBodyText());
  }

  @override
  void dispose() {
    _bodyTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.quiz1.getBodyType()) {
      case 0:
        return ElevatedButton(
          child: Text(Intl.message("Add_Text")),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    Intl.message("Add_Text"),
                    textAlign: TextAlign.center,
                  ),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text(Intl.message("Text")),
                        onPressed: () {
                          widget.updateStateCallback(1);
                          Navigator.of(context).pop(); // 다이얼로그 종료
                          // Add your action for TextField button here
                        },
                      ),
                      ElevatedButton(
                        child: Text(Intl.message("Photo")),
                        onPressed: () {
                          widget.updateStateCallback(2);
                          Navigator.of(context).pop(); // 다이얼로그 종료
                          // Add your action for Image button here
                        },
                      ),
                      // ElevatedButton(
                      //   child: Text(
                      //     '유튜브',
                      //     style:
                      //         TextStyle(decoration: TextDecoration.lineThrough),
                      //   ),
                      //   onPressed: () {
                      //     widget.updateStateCallback(3);
                      //     Navigator.of(context).pop(); // 다이얼로그 종료
                      //     // Add your action for Youtube button here
                      //   },
                      // ),
                    ],
                  ),
                );
              },
            );
          },
        );
      case 1:
        Color? bodyTextColor = getTextColor(
            widget.quizLayout.getBodyTextStyle(),
            widget.quizLayout.getColorScheme());
        Color? bodyBackgroundColor = getBackGroundColor(
            widget.quizLayout.getBodyTextStyle(),
            widget.quizLayout.getColorScheme());
        return Stack(
          children: [
            TextField(
              cursorColor: bodyTextColor,
              controller: _bodyTextController,
              decoration: InputDecoration(
                fillColor: bodyBackgroundColor,
                filled: true,
                focusColor: bodyTextColor,
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              minLines: 1, // 최소 줄 수 설정
              maxLines: null, // 최대 줄 수를 무제한으로 설정
              keyboardType: TextInputType.multiline, // 멀티라인 입력 활성화
              style: getTextFieldTextStyle(widget.quizLayout.getBodyTextStyle(),
                  widget.quizLayout.getColorScheme()),
              onChanged: (value) {
                widget.updateBodyTextCallback(value);
              },
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: Icon(Icons.close, color: bodyTextColor),
                onPressed: () {
                  widget.updateStateCallback(0);
                },
              ),
            ),
          ],
        );
      case 2:
        // 플러터 웹에서 테스트 불가. 실제 기기에서 테스트 필요
        return Stack(
          children: [
            Container(
              height: 400,
              width: 400,
              child: widget.quiz1.isImageSet()
                  ? GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final pickedFileTemp =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFileTemp != null) {
                          Uint8List file = await pickedFileTemp.readAsBytes();
                          Uint8List compressedFile =
                              await compressImage(file, 500 * 1024, 400);
                          setState(() {
                            widget.quiz1.setImageByte(compressedFile);
                          });
                        }
                      },
                      child: Image.memory(widget.quiz1.getImageByte()),

                    )
                  : IconButton(
                      icon: Icon(Icons.image),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFileTemp =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFileTemp != null) {
                          Uint8List file = await pickedFileTemp.readAsBytes();
                          Uint8List compressedFile =
                              await compressImage(file, 500 * 1024, 400);
                          setState(() {
                            widget.quiz1.setImageByte(compressedFile);
                          });
                        }
                      },
                    ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  widget.quiz1.removeImageFile(); // 이미지 파일 초기화
                  widget.updateStateCallback(0); // 상태 업데이트
                },
              ),
            ),
          ],
        );

      case 3:
        //나중에 구현 예정.
        return ElevatedButton(
          child: Text('Youtube'),
          onPressed: () {
            // Handle Youtube search
          },
        );
      default:
        return SizedBox
            .shrink(); // Return an empty widget if input doesn't match any case
    }
  }
}
