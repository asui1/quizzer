import 'package:flutter/material.dart';
import 'package:quizzer/Class/quizLayout.dart';

class AnswerCheckScreen extends StatefulWidget {
  final QuizLayout quizLayout;
  final double screenWidthModifier;
  final double screenHeightModifier;
  final Function(int) moveToQuiz;

  AnswerCheckScreen({
    required this.quizLayout,
    required this.screenWidthModifier,
    required this.screenHeightModifier,
    required this.moveToQuiz,
  });

  @override
  _AnswerCheckScreenState createState() => _AnswerCheckScreenState();
}

class _AnswerCheckScreenState extends State<AnswerCheckScreen> {
  @override
  Widget build(BuildContext context) {
    int quizCount = widget.quizLayout.getQuizCount();
    return Column(
      children: [
        Text('Answer Check Screen'),
        Expanded(
          // Wrap GridView with Expanded if it's inside a Column
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(quizCount, (index) {
              Color stateColor = widget.quizLayout.getQuiz(index).getState();
              return InkWell(
                onTap: () {
                  widget.moveToQuiz(
                      index); // Assuming you want to move to the quiz at this index
                },
                child: Row(
                  children: [
                    Text('Question ${index + 1} : '), // Displaying quiz number
                    Container(
                      width: 10,
                      height: 10,
                      color: stateColor,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
