

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzer/Widgets/LinePainter.dart';

class QuizView4 extends StatefulWidget{
  final int quizTag;

  QuizView4({Key? key, required this.quizTag}) : super(key: key);

  @override
  _QuizView4State createState() => _QuizView4State();
}

class _QuizView4State extends State<QuizView4>{
@override
Widget build(BuildContext context) {
  // MediaQuery를 사용하여 화면의 크기를 얻습니다.
  final Size screenSize = MediaQuery.of(context).size;
  final double screenWidth = screenSize.width;
  final double screenHeight = screenSize.height;

  // 선을 그릴 시작점과 끝점을 설정합니다.
  final Offset lineStart = Offset(0, screenHeight / 2);
  final Offset lineEnd = Offset(screenWidth, screenHeight / 2);

  return Scaffold(
    body: CustomPaint(
      painter: LinePainter(start: lineStart, end: lineEnd),
      child: Container(
        width: screenWidth,
        height: screenHeight,
      ),
    ),
  );
}}