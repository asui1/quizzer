import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Setup/config.dart';

class QuestionViewer extends StatelessWidget {
  final String question;
  final double fontSizeModifier;
  final QuizLayout quizLayout;

  QuestionViewer({required this.question, this.fontSizeModifier = 1, required this.quizLayout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConfig.screenWidth * 0.85, // 너비를 화면 너비의 80%로 설정
      child: Text(
        question,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: AppConfig.fontSize * 1.5 * fontSizeModifier,
          color: quizLayout.getTitleColor(),
          fontFamily: quizLayout.getQuestionFont(),
        ),
      ),
    );
  }
}


BoxDecoration backgroundDecoration({required QuizLayout quizLayout}) {
  return quizLayout.getBackgroundImage().isColor()
      ? BoxDecoration(
          color: quizLayout.getBackgroundImage().getColor(),
        )
      : BoxDecoration(
          image: DecorationImage(
            image: Image.file(File(quizLayout.getBackgroundImage().getImagePath())).image,
            fit: BoxFit.cover,
          ),
        );
}
