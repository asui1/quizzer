import 'package:flutter/material.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Setup/config.dart';
import 'package:quizzer/scoringScreen.dart';

class AnswerCheckScreen extends StatelessWidget {
  final QuizLayout quizLayout;
  final double screenWidthModifier;
  final double screenHeightModifier;
  final Function(int) moveToQuiz;
  final double heightModifier;

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
          style: TextStyle(
            color: quizLayout.getTitleColor(),
            fontSize: AppConfig.fontSize * 1.3,
          ),
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
                    answerBox(actualIndex, stateColor1),
                  ];

                  // quizCount가 홀수인 경우를 처리
                  if (actualIndex + 1 < quizCount) {
                    Color stateColor2 =
                        quizLayout.getQuiz(actualIndex + 1).getState();
                    rowChildren.add(answerBox(actualIndex + 1, stateColor2));
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScoringScreen(quizLayout: quizLayout,heightModifier: heightModifier),
                ),
              );
              
              // 채점 로직
            },
            child: const Text("채점하기"),
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
      child: answerBox(0, Colors.transparent,
          isLast: true), // 인덱스와 색상은 실제로 사용되지 않음
    );
  }

  Widget answerBox(int index, Color stateColor, {bool isLast = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: quizLayout.getBorderColor1(), // 테두리 색상
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
                '문제 ${index + 1} : ',
                style: TextStyle(
                  color: quizLayout.getTextColor(),
                  fontSize: AppConfig.fontSize,
                ),
              ), // Displaying quiz number
              Container(
                width: AppConfig.fontSize,
                height: AppConfig.fontSize,
                color: stateColor,
              ),
              SizedBox(width: AppConfig.padding), // Add space between columns
            ],
          ),
        ),
      ),
    );
  }
}
