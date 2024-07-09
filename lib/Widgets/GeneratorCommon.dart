import 'package:flutter/material.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Setup/config.dart';

class questionInputTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final QuizLayout quizLayout;

  questionInputTextField({required this.controller, required this.onChanged, required this.quizLayout});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: '질문을 입력해주세요.',
      ),
      style: TextStyle(
        fontFamily: quizLayout.getQuestionFont(),
        fontSize: AppConfig.fontSize * 1.3,
      ),
      onChanged: onChanged,
    );
  }
}

class GeneratorDoneButton extends StatelessWidget {
  final Function() onPressed;

  GeneratorDoneButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppConfig.smallPadding),
      child: Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          child: Text('완료'),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
