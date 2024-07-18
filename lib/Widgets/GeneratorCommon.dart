import 'package:flutter/material.dart';
import 'package:quizzer/Class/quizLayout.dart';
import 'package:quizzer/Setup/TextStyle.dart';
import 'package:quizzer/Setup/config.dart';

class questionInputTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final QuizLayout quizLayout;

  questionInputTextField(
      {required this.controller,
      required this.onChanged,
      required this.quizLayout});

  @override
  Widget build(BuildContext context) {
    Color? textQuestionColor = getTextColor(
        quizLayout.getQuestionTextStyle(), quizLayout.getColorScheme());
    Color? backgroundQuestionColor = getBackGroundColor(
        quizLayout.getQuestionTextStyle(), quizLayout.getColorScheme());
    return TextField(
      key: const ValueKey("QuizGeneratorQuestionField"),
      controller: controller,
      cursorColor: textQuestionColor,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: textQuestionColor ?? quizLayout.getColorScheme().primary,
          ),
        ),
        filled: true,
        focusColor: textQuestionColor,
        fillColor: backgroundQuestionColor,
        hintText: '질문을 입력해주세요.',
      ),
      style: getTextFieldTextStyle(
          quizLayout.getQuestionTextStyle(), quizLayout.getColorScheme()),
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

ElevatedButton tempSaveButton(BuildContext context, QuizLayout quizLayout) =>
    ElevatedButton(
      key: const ValueKey('tempSaveButton'),
      onPressed: () async {
        if (quizLayout.getTitle() == '') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('제목없이 저장할 수 없습니다.'),
          ));
          return;
        }
        await quizLayout.saveQuizLayout(context, true);
        Navigator.pop(context);
        Navigator.pop(context);
      },
      child: Text('임시저장'),
    );


