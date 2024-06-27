import 'package:flutter/material.dart';
import 'package:quizzer/config.dart';

class QuestionViewer extends StatelessWidget {
  final String question;

  QuestionViewer({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConfig.screenWidth * 0.85, // 너비를 화면 너비의 80%로 설정
      child: Text(
        question,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: AppConfig.fontSize * 1.5,
        ),
      ),
    );
  }
}
