

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Class/ImageColor.dart';
import '../Class/quizLayout.dart';
import '../makingQuiz.dart';

class FilpStyle12 extends StatelessWidget {
  final QuizLayout quizLayout;

  FilpStyle12({required this.quizLayout});

  @override
  Widget build(BuildContext context) {
    ImageColor imageColor = quizLayout.getButtonColor();
    int flipStyle = quizLayout.getSelectedLayout();
    Color textColor = imageColor.getColor();
    if (flipStyle != 1 && flipStyle != 2) {
      return SizedBox.shrink(); // or Container()
    }
    Widget child = Stack(
      children: <Widget>[
        Align(
          alignment:
              flipStyle == 2 ? Alignment.bottomLeft : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(8.0), // Adjust the padding as needed
            child: FloatingActionButton(
              heroTag: 'prevButtonBody',
              backgroundColor: imageColor.getColor(), // 하이라이트 여부에 따라 색상 변경
              child: Icon(Icons.arrow_back),
              onPressed: () {
                // 다음으로 넘어가는 버튼의 동작을 여기에 구현합니다.
              },
            ),
          ),
        ),
        Align(
          alignment:
              flipStyle == 2 ? Alignment.bottomRight : Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(8.0), // Adjust the padding as needed
            child: FloatingActionButton(
              heroTag: 'nextButtonBody',
              backgroundColor: imageColor.getColor(), // 하이라이트 여부에 따라 색상 변경
              child: Icon(Icons.arrow_forward),
              onPressed: () {
                  navigateToMakingQuizPage(context, quizLayout);
                // 다음으로 넘어가는 버튼의 동작을 여기에 구현합니다.
              },
            ),
          ),
        ),
      ],
    );

    return flipStyle == 2
        ? Padding(padding: EdgeInsets.only(bottom: 8.0), child: child)
        : child;
  }
}

class BottomBarStack extends StatelessWidget {
  final QuizLayout quizLayout;

  BottomBarStack({required this.quizLayout});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Icon(Icons.drag_handle, color: Colors.white),
        if (quizLayout.getSelectedLayout() == 3) ...{
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8.0), // Adjust the padding as needed
              child: FloatingActionButton(
                heroTag: 'prevButtonBottomBar',
                backgroundColor: quizLayout
                    .getButtonColor()
                    .getColor(), // 하이라이트 여부에 따라 색상 변경
                child: Icon(Icons.arrow_back),
                onPressed: () {

                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(8.0), // Adjust the padding as needed
              child: FloatingActionButton(
                heroTag: 'nextButtonBottomBar',
                backgroundColor: quizLayout
                    .getButtonColor()
                    .getColor(), // 하이라이트 여부에 따라 색상 변경
                child: Icon(Icons.arrow_forward),
                onPressed: () {
                  navigateToMakingQuizPage(context, quizLayout);
                  // 다음으로 넘어가는 버튼의 동작을 여기에 구현합니다.
                },
              ),
            ),
          ),
        },
      ],
    );
  }
}


void navigateToMakingQuizPage(BuildContext context, QuizLayout quizLayout) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MakingQuiz(quizLayout: quizLayout),
    ),
  );
}
