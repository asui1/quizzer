import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/Setup/config.dart';

class QuizView1 extends StatefulWidget {
  final Quiz1 quiz; // 퀴즈 태그
  final double screenWidthModifier;
  final double screenHeightModifier;
  final QuizLayout quizLayout;

  QuizView1(
      {Key? key,
      required this.quiz,
      this.screenHeightModifier = 1,
      this.screenWidthModifier = 1,
      required this.quizLayout})
      : super(key: key);

  @override
  _QuizView1State createState() => _QuizView1State();
}

class _QuizView1State extends State<QuizView1> {
  @override
  void initState() {
    super.initState();
    widget.quiz.viewerInit();
  }

  @override
  Widget build(BuildContext context) {
    List<bool> currentAnswer = widget.quiz.getViewerAns();

    // Future가 완료되면 UI 빌드
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration(quizLayout: widget.quizLayout),
        child: Padding(
          padding: EdgeInsets.all(AppConfig.padding),
          child: Column(
            children: <Widget>[
              QuestionViewer(
                  question: widget.quiz.getQuestion(),
                  fontSizeModifier: widget.screenWidthModifier,
                  quizLayout: widget.quizLayout),
              SizedBox(
                  height: AppConfig.screenHeight *
                      0.02 *
                      widget.screenHeightModifier),
              _buildQuizBody(
                  widget.quiz, widget.screenWidthModifier, widget.quizLayout),
              SizedBox(
                  height: AppConfig.screenHeight *
                      0.02 *
                      widget.screenHeightModifier),
              Expanded(
                child: ListView.builder(
                    itemCount: widget.quiz.getAnswers().length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Theme(
                          data: ThemeData(
                            checkboxTheme: CheckboxThemeData(
                              checkColor: WidgetStateProperty.all(
                                  widget.quizLayout.getBorderColor1()),
                              fillColor: WidgetStateProperty.all(widget
                                  .quizLayout
                                  .getSelectedColor()), // 박스 배경 색상
                            ),
                          ),
                          child: Checkbox(
                            value: currentAnswer[index],
                            onChanged: (bool? newValue) {
                              setState(() {
                                if (newValue != null) {
                                  if (widget.quiz.getViewAnsCount() <
                                          widget.quiz.getMaxAnswerSelection() ||
                                      newValue == false) {
                                    currentAnswer[index] = newValue;
                                  }
                                }
                              });
                            },
                          ),
                        ),
                        title: Text(
                          widget.quiz.getViewerAnsAt(index),
                          style: TextStyle(
                              fontSize: AppConfig.fontSize *
                                  widget.screenWidthModifier,
                              color: widget.quizLayout.getTextColor(),
                              fontFamily: widget.quizLayout.getAnswerFont()),
                        ),
                        onTap: () {
                          setState(() {
                            if (currentAnswer[index] == false) {
                              if (widget.quiz.getViewAnsCount() <
                                  widget.quiz.getMaxAnswerSelection()) {
                                currentAnswer[index] =
                                    !currentAnswer[index];
                              }
                            } else {
                              currentAnswer[index] =
                                  !currentAnswer[index];
                            }
                          });
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildQuizBody(
    Quiz1 quiz, double screenWidthModifier, QuizLayout quizLayout) {
  switch (quiz.getBodyType()) {
    case 0:
      return Container();
    case 1:
      return Container(
        width: AppConfig.screenWidth * 0.8 * screenWidthModifier,
        padding: EdgeInsets.all(8.0), // Add padding around the text
        decoration: BoxDecoration(
          border: Border.all(
              color: quizLayout
                  .getBorderColor1()), // Add black border around the container
          borderRadius:
              BorderRadius.circular(4.0), // Optional: Add rounded corners
        ),
        child: Text(
          quiz.getBodyText(),
          style: TextStyle(
            fontSize: AppConfig.fontSize * screenWidthModifier,
            color: quizLayout.getBodyTextColor(),
            fontFamily: quizLayout.getBodyFont(),
          ),
        ),
      );
    case 2:
      return Image.file(
        height: AppConfig.screenHeight * 0.3 * screenWidthModifier,
        width: AppConfig.screenWidth * 0.8 * screenWidthModifier,
        File(quiz.getImageFile().path),
        fit: BoxFit.cover,
      );
    default:
      return Container();
  }
}
