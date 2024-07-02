import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/config.dart';

class ContentWidget extends StatefulWidget {
  final BuildContext context;
  final Function(int value) updateStateCallback;
  final Quiz1 quiz1;
  final QuizLayout quizLayout;

  ContentWidget({
    Key? key,
    required this.context,
    required this.updateStateCallback,
    required this.quiz1,
    required this.quizLayout,
  }) : super(key: key);

  @override
  _ContentWidgetState createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.quiz1.getBodyType()) {
      case 0:
        return ElevatedButton(
          child: Text('본문 추가.'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    '본문 추가',
                    textAlign: TextAlign.center,
                  ),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text('텍스트'),
                        onPressed: () {
                          widget.updateStateCallback(1);
                          Navigator.of(context).pop(); // 다이얼로그 종료
                          // Add your action for TextField button here
                        },
                      ),
                      ElevatedButton(
                        child: Text('사진'),
                        onPressed: () {
                          widget.updateStateCallback(2);
                          Navigator.of(context).pop(); // 다이얼로그 종료
                          // Add your action for Image button here
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                          '유튜브',
                          style: TextStyle(decoration: TextDecoration.lineThrough),
                        ),
                        onPressed: () {
                          widget.updateStateCallback(3);
                          Navigator.of(context).pop(); // 다이얼로그 종료
                          // Add your action for Youtube button here
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      case 1:
        return Stack(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: widget.quizLayout.getBorderColor1()),
                ),
              ),
              minLines: 1, // 최소 줄 수 설정
              maxLines: null, // 최대 줄 수를 무제한으로 설정
              keyboardType: TextInputType.multiline, // 멀티라인 입력 활성화
              style: TextStyle(
                fontFamily: widget.quizLayout.getBodyFont(),
                fontSize: AppConfig.fontSize,
                color: widget.quizLayout.getBodyTextColor(),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  widget.updateStateCallback(0);
                },
              ),
            ),
          ],
        );
      case 2:
      // 플러터 웹에서 테스트 불가. 실제 기기에서 테스트 필요
        if (widget.quiz1.isImageSet()) {
          // 이미지 파일이 선택되었을 때, 선택된 이미지를 표시
          return Center(
            child: Image.file(File(widget.quiz1.getImageFile().path)),
          );
        } else {
          // 이미지 파일이 선택되지 않았을 때, 기존의 IconButton을 유지
          return IconButton(
            icon: Icon(Icons.image),
            onPressed: () async {
              final picker = ImagePicker();
              final pickedFileTemp =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedFileTemp != null) {
                setState(() {
                  widget.quiz1.setImageFile(pickedFileTemp); // 상태 업데이트
                });
              }
            },
          );
        }
      case 3:
      //나중에 구현 예정.
        return ElevatedButton(
          child: Text('Search Youtube'),
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
