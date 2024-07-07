import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/MakingQuizLayout.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:quizzer/solver.dart';

class QuizCard extends StatelessWidget {
  final String uuid;
  final String title;
  final String tags;
  final String additionalData;
  final String titleImagePath;

  QuizCard(
      {required this.uuid,
      required this.title,
      required this.titleImagePath,
      this.tags = '#테스트',
      this.additionalData = '테스트를 위한 문구입니다.'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppConfig.smallPadding), // AppConfig에서 패딩 값 가져오기
      child: Material(
        type: MaterialType
            .transparency, // This makes the material widget transparent
        child: InkWell(
          onTap: () async {
            String jsonString =
                await rootBundle.loadString('assets/jsons/$uuid.json');
            final jsonResponse = json.decode(jsonString);
            // jsonResponse를 사용하여 필요한 작업 수행

            QuizLayout quizLayout = QuizLayout();
            await quizLayout.loadQuizLayout(jsonResponse);
            if(title.contains("Maker")){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MakingQuizscreen(
                        quizLayout: quizLayout,
                      )),
            );
            }
            else{
              Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuizSolver(
                        quizLayout: quizLayout,
                        index: 0,
                      )),
            );
            }
          },
          child: Card(
              elevation: 4.0,
              child: Padding(
                padding: EdgeInsets.all(AppConfig.smallPadding),
                child: Row(
                  // Row 위젯을 사용하여 이미지와 텍스트 열을 수평으로 배열
                  children: <Widget>[
                    SizedBox(
                      width: AppConfig.shortestSide / 6, // 이미지 너비
                      height: AppConfig.shortestSide / 6, // 이미지 높이
                      child: titleImagePath.startsWith('assets/')
                          ? Image.asset(titleImagePath) // 에셋 이미지 사용
                          : Image.file(File(titleImagePath)), // 파일 이미지 사용
                    ),
                    SizedBox(
                      width: AppConfig.shortestSide * 0.05,
                    ),
                    Expanded(
                      // 이미지와 텍스트 사이의 공간을 채우기 위해 Expanded 사용
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // 텍스트를 시작 부분에서 정렬
                        children: <Widget>[
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: AppConfig.fontSize,
                                fontWeight: FontWeight.bold),
                          ), // 제목 표시
                          Text(
                            tags,
                            style:
                                TextStyle(fontSize: AppConfig.fontSize * 0.8),
                          ), // 태그 표시
                          Text(
                            additionalData,
                            style:
                                TextStyle(fontSize: AppConfig.fontSize * 0.8),
                          ), // 추가 데이터 표시
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
