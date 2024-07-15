import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzer/Class/quiz1.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Functions/Logger.dart';
import 'package:quizzer/Setup/TextStyle.dart';
import 'package:quizzer/Widgets/ViewerCommon.dart';
import 'package:quizzer/Setup/config.dart';

class QuizView1 extends StatefulWidget {
  final Quiz1 quiz; // 퀴즈 태그
  final double screenWidthModifier;
  final double screenHeightModifier;

  QuizView1({
    Key? key,
    required this.quiz,
    this.screenHeightModifier = 1,
    this.screenWidthModifier = 1,
  }) : super(key: key);

  @override
  _QuizView1State createState() => _QuizView1State();
}

class _QuizView1State extends State<QuizView1> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<bool> currentAnswer = widget.quiz.getViewerAns();
    QuizLayout quizLayout = Provider.of<QuizLayout>(context);

    // Future가 완료되면 UI 빌드
    return Theme(
      data: ThemeData.from(colorScheme: quizLayout.getColorScheme()),
      child: Scaffold(
        body: Container(
          decoration: backgroundDecoration(quizLayout: quizLayout),
          child: Padding(
            padding:
                EdgeInsets.all(AppConfig.padding * widget.screenWidthModifier),
            child: Column(
              children: <Widget>[
                QuestionViewer(
                    question: widget.quiz.getQuestion(),
                    fontSizeModifier: widget.screenWidthModifier,
                    quizLayout: quizLayout),
                SizedBox(
                    height: AppConfig.screenHeight *
                        0.02 *
                        widget.screenHeightModifier),
                _buildQuizBody(
                    widget.quiz, widget.screenWidthModifier, quizLayout),
                SizedBox(
                    height: AppConfig.screenHeight *
                        0.02 *
                        widget.screenHeightModifier),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.quiz.getAnswers().length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Container(
                            width: 40.0 *
                                widget.screenWidthModifier, // leading의 너비 조정
                            height: 40.0 *
                                widget.screenWidthModifier, // leading의 높이 조정
                            alignment: Alignment.center,
                            child: Checkbox(
                              value: currentAnswer[index],
                              onChanged: (bool? newValue) {
                                setState(() {
                                  if (newValue != null) {
                                    if (widget.quiz.getViewAnsCount() <
                                            widget.quiz
                                                .getMaxAnswerSelection() ||
                                        newValue == false) {
                                      currentAnswer[index] = newValue;
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                          title: TextStyleWidget(
                            textStyle: quizLayout.getTextStyle(2),
                            text: widget.quiz.getViewerAnsAt(index),
                            colorScheme: quizLayout.getColorScheme(),
                            modifier: widget.screenWidthModifier,
                          ),
                          onTap: () {
                            setState(() {
                              if (currentAnswer[index] == false) {
                                if (widget.quiz.getViewAnsCount() <
                                    widget.quiz.getMaxAnswerSelection()) {
                                  currentAnswer[index] = !currentAnswer[index];
                                }
                              } else {
                                currentAnswer[index] = !currentAnswer[index];
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
        width: AppConfig.screenWidth * 0.95 * screenWidthModifier,

        padding: EdgeInsets.all(3.0), // Add padding around the text
        child: TextStyleWidget(
          textStyle: quizLayout.getTextStyle(1),
          text: quiz.getBodyText(),
          colorScheme: quizLayout.getColorScheme(),
          modifier: screenWidthModifier,
        ),
      );
    case 2:
      return Image.file(
        height: AppConfig.screenHeight * 0.3 * screenWidthModifier,
        width: AppConfig.screenWidth * 0.95 * screenWidthModifier,
        File(quiz.getImageFile().path),
        fit: BoxFit.cover,
      );
    default:
      return Container();
  }
}
