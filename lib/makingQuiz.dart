

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Class/quizLayout.dart';


class MakingQuiz extends StatefulWidget {
  final QuizLayout quizLayout;

  MakingQuiz({required this.quizLayout});

  @override
  _MakingQuizState createState() => _MakingQuizState();
}

class _MakingQuizState extends State<MakingQuiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Making Quiz'),
      ),
      body: Center(
        child: Text('Quiz Layout: ${widget.quizLayout.toString()}'),
      ),
    );
  }
}

