import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Functions/keys.dart';
import 'package:quizzer/Functions/makeHash.dart';
import 'package:quizzer/Functions/serverRequests.dart';
import 'package:quizzer/Functions/sharedPreferences.dart';
import 'package:quizzer/Setup/Colors.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/Screens/scoringScreen.dart';

class AnswerCheckScreen extends StatelessWidget {
  final QuizLayout quizLayout;
  final double screenWidthModifier;
  final double screenHeightModifier;
  final Function(int) moveToQuiz;
  final double heightModifier;
  bool _isTapInProgress = false;

  AnswerCheckScreen({
    required this.quizLayout,
    required this.screenWidthModifier,
    required this.screenHeightModifier,
    required this.moveToQuiz,
    required this.heightModifier,
  });

  @override
  Widget build(BuildContext context) {
    int quizCount = quizLayout.getQuizCount();
    return Column(
      children: [
        SizedBox(
          height: AppConfig.largePadding,
        ),
        Text(
          quizLayout.getTitle(),
        ),
        SizedBox(
          height: AppConfig.padding,
        ),
        Expanded(
          // Wrap GridView with Expanded if it's inside a Column
          child: Center(
            child: ListView.builder(
                itemCount: (quizCount + 1) ~/ 2, // itemCount를 절반으로 조정
                itemBuilder: (context, index) {
                  int actualIndex = index * 2; // 실제 인덱스 계산
                  Color stateColor1 =
                      quizLayout.getQuiz(actualIndex).getState();
                  List<Widget> rowChildren = [
                    Spacer(
                      flex: 1,
                    ),
                    answerBox(actualIndex, stateColor1, quizLayout),
                  ];

                  // quizCount가 홀수인 경우를 처리
                  if (actualIndex + 1 < quizCount) {
                    Color stateColor2 =
                        quizLayout.getQuiz(actualIndex + 1).getState();
                    rowChildren.add(
                        answerBox(actualIndex + 1, stateColor2, quizLayout));
                  } else {
                    // 홀수 번째 항목에 대해 눈에 보이지 않는 answerBox 추가
                    rowChildren.add(InvisibleAnswerBox());
                  }

                  rowChildren.add(Spacer(
                    flex: 1,
                  ));

                  return Row(
                    children: rowChildren,
                  );
                }),
          ),
        ),
        SizedBox(
          height: AppConfig.padding,
        ),
        SizedBox(
          width: AppConfig.screenWidth * screenWidthModifier / 2, // 원하는 너비 설정
          child: FloatingActionButton(
            onPressed: () async {
              if (_isTapInProgress) return;
              _isTapInProgress = true;
              int score = quizLayout.getScore();
              sendResultToServer(score, quizLayout);
              String userEmail =
                  await UserPreferences.getUserEmail() ?? 'GUEST';
              String userName = await UserPreferences.getUserName() ?? 'GUEST';
              String resultUrl = quizzerDomain +
                  "#/result/?resultId=" +
                  generateUniqueId(
                      quizLayout.getUuid(), userEmail, quizLayout.getTitle());
              Logger.log(resultUrl);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScoringScreen(
                    quizLayout: quizLayout,
                    heightModifier: heightModifier,
                    score: score,
                    resultUrl: resultUrl,
                    userName: userName,
                  ),
                ),
              );
              _isTapInProgress = false;
            },
            child: Text(Intl.message('Grade')),
            // FloatingActionButton의 기본 크기를 무시하고, SizedBox의 크기에 맞춰서 조절됩니다.
          ),
        ),
        SizedBox(
          height: AppConfig.largePadding,
        ),
      ],
    );
  }

  Widget InvisibleAnswerBox() {
    return Opacity(
      opacity: 0.0,
      child: answerBox(0, Colors.transparent, quizLayout,
          isLast: true), // 인덱스와 색상은 실제로 사용되지 않음
    );
  }

  Widget answerBox(int index, Color stateColor, QuizLayout quizLayout,
      {bool isLast = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: quizLayout.getColorScheme().onSurface,
          width: 2.0, // 테두리 두께
        ),
      ),
      child: InkWell(
        onTap: () {
          isLast
              ? null
              : moveToQuiz(
                  index); // Assuming you want to move to the quiz at this index
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0), // InkWell 내부 여백
          child: Row(
            mainAxisSize: MainAxisSize.min, // Row의 크기를 내용물에 맞춤
            children: [
              SizedBox(width: AppConfig.padding), // Add space between columns
              Text(
                Intl.message("Prob") + ' ${index + 1} : ',
                style: TextStyle(
                  fontFamily: quizLayout.getAnswerFont(),
                  fontSize: AppConfig.fontSize,
                  color: quizLayout.getColorScheme().primary,
                ),
              ), // Displaying quiz number
              stateColor == MyColors().red
                  ? Icon(
                      Icons.warning,
                      color: quizLayout.getColorScheme().error,
                      size: AppConfig.fontSize,
                    )
                  : Icon(
                      Icons.check,
                      color: quizLayout.getColorScheme().primary,
                      size: AppConfig.fontSize,
                    ),
              SizedBox(width: AppConfig.padding), // Add space between columns
            ],
          ),
        ),
      ),
    );
  }
}
