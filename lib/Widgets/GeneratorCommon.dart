import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        hintText: Intl.message("Enter_Question"),
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
          child: Text(Intl.message("Done")),
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
            content: Text(Intl.message("Cant_save_without_title")),
          ));
          return;
        }
        await quizLayout.saveQuizLayout(context, true);
        WidgetsBinding.instance.addPostFrameCallback((_) {

                  Navigator.of(context).popUntil((route) => route.isFirst);

      });}, 
      child: Text(Intl.message("Temp_Save")),
    );
