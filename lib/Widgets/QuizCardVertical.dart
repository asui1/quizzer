import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/serverRequests.dart';
import 'package:quizzer/Screens/solver.dart';
import 'package:quizzer/Setup/config.dart';

class QuizCardVertical extends StatelessWidget {
  final String uuid;
  final String title;
  final List<String> tags;
  final String creator;
  final String? titleImagePath;
  final int counts;
  QuizCardVertical(
      {required this.uuid,
      required this.title,
      required this.titleImagePath,
      this.tags = const ['#테스트'],
      this.creator = 'GUEST',
      this.counts = 0});

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
            // jsonResponse를 사용하여 필요한 작업 수행

            QuizLayout quizLayout =
                Provider.of<QuizLayout>(context, listen: false);
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
          child: Column(
            children: <Widget>[
              Card(
                elevation: 4.0,
                child: Padding(
                  padding: EdgeInsets.all(AppConfig.smallPadding),
                  child: SizedBox(
                    width: AppConfig.shortestSide / 5, // 이미지 너비
                    height: AppConfig.shortestSide / 5, // 이미지 높이
                    child: titleImagePath == null
                        ? Image.asset(
                            'assets/images/question2.png') // 에셋 이미지 사용
                        : Image.file(File(titleImagePath!)), // 파일 이미지 사용
                  ),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: AppConfig.fontSize, fontWeight: FontWeight.bold),
              ), // 제목 표시
              Text(
                creator,
                style: TextStyle(
                    fontSize: AppConfig.fontSize * 0.8,
                    fontWeight: FontWeight.w200), // 추가 데이터 표시
              ), // 추가 데이터 표시
              Chip(
                padding: EdgeInsets.all(4),
                labelPadding: EdgeInsets.all(2),
                label: Text(
                  tags.length == 0 ? "" : tags[0],
                  style: TextStyle(
                      fontSize: AppConfig.fontSize * 0.6,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
