import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/serverRequests.dart';
import 'package:quizzer/Setup/config.dart';
import 'dart:convert';

import 'package:quizzer/Screens/solver.dart';

class QuizCard extends StatelessWidget {
  final String uuid;
  final String title;
  final List<String> tags;
  final String additionalData;
  final String? titleImagePath;

  QuizCard(
      {required this.uuid,
      required this.title,
      required this.titleImagePath,
      this.tags = const ['#테스트'],
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
            String dataJson = "";
            final directory = await getApplicationDocumentsDirectory();
            try {
              await downloadJson(directory, uuid);
              String jsonString = await loadFileContent(directory, uuid);
              final jsonResponse = json.decode(jsonString);
              dataJson = jsonResponse['Data'];
            } catch (e) {
              Logger.log("Error in downloadJson");
              Logger.log(e);
              return;
            }
            // Logger.log(dataJson);

            final jsonResponse = json.decode(dataJson);
            Logger.log(jsonResponse);
            // jsonResponse를 사용하여 필요한 작업 수행

            QuizLayout quizLayout = Provider.of<QuizLayout>(context, listen: false);
            quizLayout.reset();
            await quizLayout.loadQuizLayout(jsonResponse);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuizSolver(
                        quizLayout: quizLayout,
                        index: 0,
                      )),
            );
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
                      child: titleImagePath == null
                          ? Image.asset(
                              'assets/images/question2.png') // 에셋 이미지 사용
                          : Image.file(File(titleImagePath!)), // 파일 이미지 사용
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
                          Container(
                            height: 20.0,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 8.0, // 태그 사이의 가로 간격
                              runSpacing: 4.0, // 태그 사이의 세로 간격
                              children: tags.map((tag) {
                                return Chip(
                                  label: Text(tag),
                                );
                              }).toList(),
                            ),
                          ),
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
