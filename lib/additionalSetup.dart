import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Setup/Strings.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';

class quizLayoutAdditionalSetup extends StatefulWidget {
  final QuizLayout quizLayout;
  quizLayoutAdditionalSetup({required this.quizLayout});
  @override
  _quizLayoutAdditionalSetup createState() => _quizLayoutAdditionalSetup();
}

class _quizLayoutAdditionalSetup extends State<quizLayoutAdditionalSetup> {
  int itemCount = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration(quizLayout: widget.quizLayout),
        child: Column(
          children: [
            SizedBox(
                height: AppConfig.screenHeight * 0.05), // 여기에 원하는 높이를 설정하세요.
            Expanded(
              child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      index != itemCount - 1
                          ? showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('폰트 선택'),
                                  content: Container(
                                    width: double.maxFinite,
                                    child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2, // 한 줄에 2개의 항목을 표시
                                        childAspectRatio:
                                            1.5, // 항목의 가로 세로 비율을 1:1로 설정
                                        crossAxisSpacing: 10, // 가로 방향 항목의 간격
                                        mainAxisSpacing: 10, // 세로 방향 항목의 간격
                                      ),
                                      itemCount: MyFonts.count, // 전체 항목 수
                                      itemBuilder: (context, index2) {
                                        return InkWell(
                                          onTap: () {
                                            // 여기에 탭 이벤트 처리 로직을 추가하세요.
                                            // 예: 선택된 폰트를 사용하여 무언가를 업데이트하거나, 사용자에게 알림을 표시합니다.
                                            widget.quizLayout.setFontFamily(
                                                index,
                                                MyFonts.getFontByIndex(index2));
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '가나다 abc 123', // 표시할 텍스트
                                              style: TextStyle(
                                                fontFamily:
                                                    MyFonts.getFontByIndex(
                                                        index2), // 폰트 패밀리 적용
                                                fontSize: AppConfig.fontSize *
                                                    0.8, // 폰트 크기
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200], // 배경색
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // 모서리 둥글게
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text('취소'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                );
                              },
                            )
                          : null;
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: AppConfig.largePadding,
                          vertical: AppConfig.padding),
                      decoration: BoxDecoration(
                        color: Colors.transparent, // 컨테이너를 투명하게 만듭니다.
                        border: Border.all(width: 2),
                        borderRadius:
                            BorderRadius.circular(10), // 모서리를 둥글게 처리합니다.
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppConfig.padding),
                        child: Text(
                          stringResources['quizLayoutSetup${index + 1}']!,
                          style: TextStyle(
                            fontSize: AppConfig.fontSize,
                            fontFamily: widget.quizLayout.getFontFamily(index),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
